-- | Index management functions such as document mapping and ingest
module Monocle.Backend.Index where

import Data.Aeson (object)
import qualified Data.ByteString.Base64 as B64
import qualified Data.HashTable.IO as H
import qualified Data.Map as Map
import qualified Data.Text as Text
import Data.Time
import qualified Data.Vector as V
import qualified Database.Bloodhound as BH
import qualified Database.Bloodhound.Raw as BHR
import Google.Protobuf.Timestamp as T
import qualified Monocle.Api.Config as Config
import Monocle.Backend.Documents
import qualified Monocle.Backend.Queries as Q
import Monocle.Change
import Monocle.Crawler (EntityEntity (EntityEntityProjectName))
import qualified Monocle.Crawler as CrawlerPB
import Monocle.Env
import Monocle.Logging (Entity (..), getEntityName)
import Monocle.Prelude
import Monocle.Search (Order (..), Order_Direction (..), TaskData (..))
import qualified Network.HTTP.Client as HTTP
import qualified Network.HTTP.Types.Status as NHTS
import qualified Proto3.Suite.Types as PT (Enumerated (..))
import qualified Streaming as S (chunksOf)
import qualified Streaming.Prelude as S

data ConfigIndexMapping = ConfigIndexMapping deriving (Eq, Show)

instance ToJSON ConfigIndexMapping where
  toJSON ConfigIndexMapping =
    object
      [ "properties"
          .= object
            ["version" .= object ["type" .= ("integer" :: Text)]]
      ]

data ChangesIndexMapping = ChangesIndexMapping deriving (Eq, Show)

instance ToJSON ChangesIndexMapping where
  toJSON ChangesIndexMapping =
    object
      [ "properties"
          .= object
            [ "id" .= object ["type" .= ("keyword" :: Text)],
              "type" .= object ["type" .= ("keyword" :: Text)],
              "number" .= object ["type" .= ("keyword" :: Text)],
              "change_id" .= object ["type" .= ("keyword" :: Text)],
              "title"
                .= object
                  [ "type" .= ("text" :: Text),
                    "fields"
                      .= object
                        [ "keyword"
                            .= object
                              [ "type" .= ("keyword" :: Text),
                                "ignore_above" .= (8191 :: Int)
                              ]
                        ]
                  ],
              "text"
                .= object
                  [ "type" .= ("text" :: Text),
                    "fields"
                      .= object
                        [ "keyword"
                            .= object
                              [ "type" .= ("keyword" :: Text),
                                "ignore_above" .= (8191 :: Int)
                              ]
                        ]
                  ],
              "url" .= object ["type" .= ("keyword" :: Text)],
              "commit_count" .= object ["type" .= ("integer" :: Text)],
              "additions" .= object ["type" .= ("integer" :: Text)],
              "deletions" .= object ["type" .= ("integer" :: Text)],
              "change_files_count" .= object ["type" .= ("integer" :: Text)],
              "changed_files"
                .= object
                  [ "properties"
                      .= object
                        [ "additions" .= object ["type" .= ("integer" :: Text)],
                          "deletions" .= object ["type" .= ("integer" :: Text)],
                          "path" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "commits"
                .= object
                  [ "properties"
                      .= object
                        [ "sha" .= object ["type" .= ("keyword" :: Text)],
                          "author"
                            .= object
                              [ "properties"
                                  .= object
                                    [ "uid" .= object ["type" .= ("keyword" :: Text)],
                                      "muid" .= object ["type" .= ("keyword" :: Text)]
                                    ]
                              ],
                          "committer"
                            .= object
                              [ "properties"
                                  .= object
                                    [ "uid" .= object ["type" .= ("keyword" :: Text)],
                                      "muid" .= object ["type" .= ("keyword" :: Text)]
                                    ]
                              ],
                          "authored_at"
                            .= object
                              [ "type" .= ("date" :: Text),
                                "format" .= ("date_time_no_millis" :: Text)
                              ],
                          "committed_at"
                            .= object
                              [ "type" .= ("date" :: Text),
                                "format" .= ("date_time_no_millis" :: Text)
                              ],
                          "additions" .= object ["type" .= ("integer" :: Text)],
                          "deletions" .= object ["type" .= ("integer" :: Text)],
                          "title" .= object ["type" .= ("text" :: Text)]
                        ]
                  ],
              "repository_prefix" .= object ["type" .= ("keyword" :: Text)],
              "repository_fullname" .= object ["type" .= ("keyword" :: Text)],
              "repository_shortname" .= object ["type" .= ("keyword" :: Text)],
              "author"
                .= object
                  [ "properties"
                      .= object
                        [ "uid" .= object ["type" .= ("keyword" :: Text)],
                          "muid" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "on_author"
                .= object
                  [ "properties"
                      .= object
                        [ "uid" .= object ["type" .= ("keyword" :: Text)],
                          "muid" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "committer"
                .= object
                  [ "properties"
                      .= object
                        [ "uid" .= object ["type" .= ("keyword" :: Text)],
                          "muid" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "merged_by"
                .= object
                  [ "properties"
                      .= object
                        [ "uid" .= object ["type" .= ("keyword" :: Text)],
                          "muid" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "branch" .= object ["type" .= ("keyword" :: Text)],
              "target_branch" .= object ["type" .= ("keyword" :: Text)],
              "created_at"
                .= object
                  [ "type" .= ("date" :: Text),
                    "format" .= ("date_time_no_millis" :: Text)
                  ],
              "on_created_at"
                .= object
                  [ "type" .= ("date" :: Text),
                    "format" .= ("date_time_no_millis" :: Text)
                  ],
              "merged_at"
                .= object
                  [ "type" .= ("date" :: Text),
                    "format" .= ("date_time_no_millis" :: Text)
                  ],
              "updated_at"
                .= object
                  [ "type" .= ("date" :: Text),
                    "format" .= ("date_time_no_millis" :: Text)
                  ],
              "closed_at"
                .= object
                  [ "type" .= ("date" :: Text),
                    "format" .= ("date_time_no_millis" :: Text)
                  ],
              "state"
                .= object ["type" .= ("keyword" :: Text)],
              "duration" .= object ["type" .= ("integer" :: Text)],
              "mergeable" .= object ["type" .= ("keyword" :: Text)],
              "labels" .= object ["type" .= ("keyword" :: Text)],
              "assignees"
                .= object
                  [ "type" .= ("nested" :: Text),
                    "properties"
                      .= object
                        [ "uid" .= object ["type" .= ("keyword" :: Text)],
                          "muid" .= object ["type" .= ("keyword" :: Text)]
                        ]
                  ],
              "approval" .= object ["type" .= ("keyword" :: Text)],
              "draft" .= object ["type" .= ("boolean" :: Text)],
              "self_merged" .= object ["type" .= ("boolean" :: Text)],
              "crawler_metadata"
                .= object
                  [ "properties"
                      .= object
                        [ "crawler_name" .= object ["type" .= ("keyword" :: Text)],
                          "crawler_type" .= object ["type" .= ("keyword" :: Text)],
                          "crawler_type_value" .= object ["type" .= ("keyword" :: Text)],
                          "last_commit_at"
                            .= object
                              [ "type" .= ("date" :: Text),
                                "format" .= ("date_time_no_millis" :: Text)
                              ],
                          "last_post_at"
                            .= object
                              [ "type" .= ("date" :: Text),
                                "format" .= ("date_time_no_millis" :: Text)
                              ],
                          "total_docs_posted" .= object ["type" .= ("integer" :: Text)],
                          "total_changes_updated" .= object ["type" .= ("integer" :: Text)],
                          "total_change_events_updated" .= object ["type" .= ("integer" :: Text)],
                          "total_orphans_updated" .= object ["type" .= ("integer" :: Text)]
                        ]
                  ],
              "tasks_data"
                .= object
                  [ "properties"
                      .= object
                        [ "tid" .= object ["type" .= ("keyword" :: Text)],
                          "ttype" .= object ["type" .= ("keyword" :: Text)],
                          "crawler_name" .= object ["type" .= ("keyword" :: Text)],
                          "updated_at"
                            .= object
                              [ "type" .= ("date" :: Text),
                                "format" .= ("date_time_no_millis" :: Text)
                              ],
                          "change_url" .= object ["type" .= ("keyword" :: Text)],
                          "severity" .= object ["type" .= ("keyword" :: Text)],
                          "priority" .= object ["type" .= ("keyword" :: Text)],
                          "score" .= object ["type" .= ("integer" :: Text)],
                          "url" .= object ["type" .= ("keyword" :: Text)],
                          "prefix" .= object ["type" .= ("keyword" :: Text)],
                          "title"
                            .= object
                              [ "type" .= ("text" :: Text),
                                "fields"
                                  .= object
                                    [ "keyword"
                                        .= object
                                          [ "type" .= ("keyword" :: Text),
                                            "ignore_above" .= (8191 :: Int)
                                          ]
                                    ]
                              ],
                          "_adopted" .= object ["type" .= ("boolean" :: Text)]
                        ]
                  ]
            ]
      ]

createIndex :: (BH.MonadBH m, ToJSON mapping, MonadFail m) => BH.IndexName -> mapping -> m ()
createIndex indexName mapping = do
  _respCI <- BH.createIndex indexSettings indexName
  -- print respCI
  _respPM <- BH.putMapping indexName mapping
  -- print respPM
  True <- BH.indexExists indexName
  pure ()
  where
    indexSettings = BH.IndexSettings (BH.ShardCount 1) (BH.ReplicaCount 0)

configIndex :: BH.IndexName
configIndex = BH.IndexName "monocle.config"

configDoc :: BH.DocId
configDoc = BH.DocId "config"

-- | Upgrade to config v1 (migrate legacy GH crawler to the new API)
-- | This function looks for GitHub project crawler metadata docs and reset the
-- | lastCommitAt to the lastUpdatedAt date of the most recent change of the repository.
upgradeConfigV1 :: QueryM ()
upgradeConfigV1 = do
  QueryWorkspace ws <- asks tenant
  -- Get GitHub crawler names
  let ghCrawlerNames = getGHCrawlerNames ws
  -- Get all the GH crawler project metadata.
  ghCrawlerMD <- traverse getProjectCrawlerMDByName ghCrawlerNames
  -- Keep the one that have the default starting date
  let ghCrawlerMDToReset = filter (isCrawlerLastCommitAtIsDefault ws) $ concat ghCrawlerMD
  -- Update the last_commit_at from the age of the most recent update
  traverse_ setLastUpdatedDate ghCrawlerMDToReset
  where
    getGHCrawlerNames :: Config.Index -> [Text]
    getGHCrawlerNames ws =
      let isGHProvider crawler = case Config.provider crawler of
            Config.GithubProvider _ -> True
            _otherwise -> False
       in Config.getCrawlerName
            <$> filter isGHProvider (Config.crawlers ws)
    getProjectCrawlerMDByName :: Text -> QueryM [ECrawlerMetadata]
    getProjectCrawlerMDByName crawlerName = do
      let entity = EntityEntityProjectName ""
          search = BH.mkSearch (Just $ crawlerMDQuery entity crawlerName) Nothing
      index <- getIndexName
      resp <- fmap BH.hitSource <$> simpleSearch index search
      pure $ catMaybes resp
    isCrawlerLastCommitAtIsDefault :: Config.Index -> ECrawlerMetadata -> Bool
    isCrawlerLastCommitAtIsDefault
      ws
      ( ECrawlerMetadata
          ECrawlerMetadataObject {ecmCrawlerName, ecmLastCommitAt}
        ) =
        case Config.lookupCrawler ws (from ecmCrawlerName) of
          Nothing -> False
          Just crawler -> getWorkerUpdatedSince crawler == ecmLastCommitAt
    setLastUpdatedDate :: ECrawlerMetadata -> QueryM ()
    setLastUpdatedDate
      (ECrawlerMetadata ECrawlerMetadataObject {ecmCrawlerName, ecmCrawlerTypeValue}) = do
        lastUpdatedDateM <- getLastUpdatedDate $ from ecmCrawlerTypeValue
        case lastUpdatedDateM of
          Nothing -> pure ()
          Just lastUpdatedAt ->
            setLastUpdated
              (from ecmCrawlerName)
              lastUpdatedAt
              $ Project . from $ ecmCrawlerTypeValue

newtype ConfigVersion = ConfigVersion Integer deriving (Eq, Show)

-- | Extract the `version` attribute of an Aeson object value
--
-- >>> getVersion (object ["version" .= (42 :: Int)])
-- ConfigVersion 42
-- >>> getVersion (object [])
-- ConfigVersion 0
getVersion :: Value -> ConfigVersion
getVersion = ConfigVersion . fromMaybe 0 . preview (_Object . at "version" . traverse . _Integer)

-- | Set the `version` attribute of an Aeson object
--
-- >>> setVersion (ConfigVersion 23) (object ["version" .= (22 :: Int)])
-- Object (fromList [("version",Number 23.0)])
-- >>> setVersion (ConfigVersion 42) (object [])
-- Object (fromList [("version",Number 42.0)])
setVersion :: ConfigVersion -> Value -> Value
setVersion (ConfigVersion v) = set (_Object . at "version") (Just . Number . fromInteger $ v)

getConfigVersion :: QueryM (ConfigVersion, Value)
getConfigVersion = do
  QueryConfig _ <- asks tenant
  currentConfig <- fromMaybe (object []) <$> getDocumentById' configIndex configDoc
  pure (getVersion currentConfig, currentConfig)

ensureConfigIndex :: QueryM ()
ensureConfigIndex = do
  QueryConfig conf <- asks tenant
  createIndex configIndex ConfigIndexMapping
  (currentVersion, currentConfig) <- getConfigVersion

  when (currentVersion == ConfigVersion 0) $ traverseWorkspace upgradeConfigV1 conf

  let newConfig = setVersion (ConfigVersion 1) currentConfig
  void $ BH.indexDocument configIndex BH.defaultIndexDocumentSettings newConfig configDoc
  where
    -- traverseWorkspace replace the QueryEnv tenant attribute from QueryConfig to QueryWorkspace
    traverseWorkspace action conf = do
      traverse_ (\ws -> local (setTenant ws) action) (Config.getWorkspaces conf)
    setTenant ws e = e {tenant = QueryWorkspace ws}

ensureIndexSetup :: QueryM ()
ensureIndexSetup = do
  indexName <- getIndexName
  createIndex indexName ChangesIndexMapping
  BHR.settings indexName (object ["index" .= object ["max_regex_length" .= (50_000 :: Int)]])

ensureIndexCrawlerMetadata :: QueryM ()
ensureIndexCrawlerMetadata = do
  config <- getIndexConfig
  traverse_ initCrawlerMetadata $ Config.crawlers config

withRefresh :: HasCallStack => QueryM BH.Reply -> QueryM ()
withRefresh action = do
  index <- getIndexName
  resp <- action
  unless (BH.isSuccess resp) (error $ "Unable to add or update: " <> show resp)
  refreshResp <- BH.refreshIndex index
  unless (BH.isSuccess refreshResp) (error $ "Unable to refresh index: " <> show resp)

ensureIndex :: QueryM ()
ensureIndex = do
  ensureIndexSetup
  ensureIndexCrawlerMetadata

removeIndex :: QueryM ()
removeIndex = do
  indexName <- getIndexName
  _resp <- BH.deleteIndex indexName
  False <- BH.indexExists indexName
  pure ()

toAuthor :: Maybe Monocle.Change.Ident -> Monocle.Backend.Documents.Author
toAuthor (Just Monocle.Change.Ident {..}) =
  Monocle.Backend.Documents.Author
    { authorMuid = identMuid,
      authorUid = identUid
    }
toAuthor Nothing =
  Monocle.Backend.Documents.Author
    "backend-ghost"
    "backend-ghost"

toEChangeEvent :: ChangeEvent -> EChangeEvent
toEChangeEvent ChangeEvent {..} =
  EChangeEvent
    { echangeeventId = changeEventId,
      echangeeventNumber = fromIntegral changeEventNumber,
      echangeeventType = getEventType changeEventType,
      echangeeventChangeId = changeEventChangeId,
      echangeeventUrl = changeEventUrl,
      echangeeventChangedFiles = SimpleFile . changedFilePathPath <$> toList changeEventChangedFiles,
      echangeeventRepositoryPrefix = changeEventRepositoryPrefix,
      echangeeventRepositoryFullname = changeEventRepositoryFullname,
      echangeeventRepositoryShortname = changeEventRepositoryShortname,
      echangeeventAuthor = Just $ toAuthor changeEventAuthor,
      echangeeventOnAuthor = toAuthor changeEventOnAuthor,
      echangeeventBranch = changeEventBranch,
      echangeeventLabels = Just . toList $ changeEventLabels,
      echangeeventCreatedAt = T.toUTCTime $ fromMaybe (error "changeEventCreatedAt field is mandatory") changeEventCreatedAt,
      echangeeventOnCreatedAt = T.toUTCTime $ fromMaybe (error "changeEventOnCreatedAt field is mandatory") changeEventOnCreatedAt,
      echangeeventApproval = case changeEventType of
        Just (ChangeEventTypeChangeReviewed (ChangeReviewedEvent approval)) -> Just $ toList approval
        _anyOtherApprovals -> Nothing,
      echangeeventTasksData = Nothing
    }

getEventType :: Maybe ChangeEventType -> EDocType
getEventType eventTypeM = case eventTypeM of
  Just eventType -> case eventType of
    ChangeEventTypeChangeCreated ChangeCreatedEvent -> EChangeCreatedEvent
    ChangeEventTypeChangeCommented ChangeCommentedEvent -> EChangeCommentedEvent
    ChangeEventTypeChangeAbandoned ChangeAbandonedEvent -> EChangeAbandonedEvent
    ChangeEventTypeChangeReviewed (ChangeReviewedEvent _) -> EChangeReviewedEvent
    ChangeEventTypeChangeCommitForcePushed ChangeCommitForcePushedEvent -> EChangeCommitForcePushedEvent
    ChangeEventTypeChangeCommitPushed ChangeCommitPushedEvent -> EChangeCommitPushedEvent
    ChangeEventTypeChangeMerged ChangeMergedEvent -> EChangeMergedEvent
  Nothing -> error "changeEventType field is mandatory"

toETaskData :: Text -> TaskData -> ETaskData
toETaskData crawlerName TaskData {..} =
  let tdTid = toText taskDataTid
      tdCrawlerName = Just crawlerName
      tdTtype = toList $ toText <$> taskDataTtype
      tdChangeUrl = toText taskDataChangeUrl
      tdSeverity = toText taskDataSeverity
      tdPriority = toText taskDataPriority
      tdScore = fromInteger $ toInteger taskDataScore
      tdUrl = toText taskDataUrl
      tdTitle = toText taskDataTitle
      tdPrefix = Just $ toText taskDataPrefix
      -- We might get a maybe Timestamp - do not fail if Nothing
      tdUpdatedAt = toMonocleTime $ maybe defaultDate T.toUTCTime taskDataUpdatedAt
   in ETaskData {..}
  where
    defaultDate = [utctime|1960-01-01 00:00:00|]

-- | Apply a stream of bulk operation by chunk
bulkStream :: Stream (Of BH.BulkOperation) QueryM () -> QueryM Int
bulkStream s = do
  (count :> _) <- S.sum . S.mapM callBulk . S.mapped S.toList . S.chunksOf 500 $ s
  when (count > 0) $
    -- TODO: check for refresh errors ?
    void $ BH.refreshIndex =<< getIndexName
  pure count
  where
    callBulk :: [BH.BulkOperation] -> QueryM Int
    callBulk ops = do
      let vector = V.fromList ops
      _ <- BH.bulk vector
      -- TODO: check for error
      pure $ V.length vector

runAddDocsBulkOPs ::
  -- | The helper function to create the bulk operation
  (BH.IndexName -> (Value, BH.DocId) -> BH.BulkOperation) ->
  -- | The docs payload
  [(Value, BH.DocId)] ->
  QueryM ()
runAddDocsBulkOPs bulkOp docs = do
  index <- getIndexName
  let stream = V.fromList $ fmap (bulkOp index) docs
  _ <- BH.bulk stream
  -- Bulk loads require an index refresh before new data is loaded.
  _ <- BH.refreshIndex index
  pure ()

indexDocs :: [(Value, BH.DocId)] -> QueryM ()
indexDocs = runAddDocsBulkOPs toBulkIndex
  where
    -- BulkIndex operation: Create the document, replacing it if it already exists.
    toBulkIndex index (doc, docId) = BH.BulkIndex index docId doc

updateDocs :: [(Value, BH.DocId)] -> QueryM ()
updateDocs = runAddDocsBulkOPs toBulkUpdate
  where
    -- BulkUpdate operation: Update the document, merging the new value with the existing one.
    toBulkUpdate index (doc, docId) = BH.BulkUpdate index docId doc

upsertDocs :: [(Value, BH.DocId)] -> QueryM ()
upsertDocs = runAddDocsBulkOPs toBulkUpsert
  where
    -- BulkUpsert operation: Update the document if it already exists, otherwise insert it.
    toBulkUpsert index (doc, docId) = BH.BulkUpsert index docId (BH.UpsertDoc doc) []

-- | Generated base64 encoding of Text
getBase64Text :: Text -> Text
getBase64Text = decodeUtf8 . B64.encode . encodeUtf8

-- | A simple scan search that loads all the results in memory
runScanSearch :: forall a. FromJSONField a => BH.Query -> QueryM [a]
runScanSearch query = withQuery (mkQuery [query]) Q.scanSearchSimple

getChangeDocId :: EChange -> BH.DocId
getChangeDocId change = BH.DocId . toText $ echangeId change

indexChanges :: [EChange] -> QueryM ()
indexChanges changes = indexDocs $ fmap (toDoc . ensureType) changes
  where
    toDoc change = (toJSON change, getChangeDocId change)
    ensureType change = change {echangeType = EChangeDoc}

getEventDocId :: EChangeEvent -> BH.DocId
getEventDocId event = BH.DocId . toStrict $ echangeeventId event

indexEvents :: [EChangeEvent] -> QueryM ()
indexEvents events = indexDocs (fmap toDoc events)
  where
    toDoc ev = (toJSON ev, getEventDocId ev)

statusCheck :: (Int -> c) -> HTTP.Response body -> c
statusCheck prd = prd . NHTS.statusCode . HTTP.responseStatus

isNotFound :: BH.Reply -> Bool
isNotFound = statusCheck (== 404)

checkDocExists :: BH.DocId -> QueryM Bool
checkDocExists docId = do
  index <- getIndexName
  BH.documentExists index docId

getDocumentById' :: (BH.MonadBH m, FromJSON a, MonadThrow m) => BH.IndexName -> BH.DocId -> m (Maybe a)
getDocumentById' index docId = do
  resp <- BH.getDocument index docId
  if isNotFound resp
    then pure Nothing
    else do
      parsed <- BH.parseEsResponse resp
      case parsed of
        Right cm -> pure . getHit $ BH.foundResult cm
        Left _ -> error "Unable to get parse result"
  where
    getHit (Just (BH.EsResultFound _ cm)) = Just cm
    getHit Nothing = Nothing

getDocumentById :: FromJSON a => BH.DocId -> QueryM (Maybe a)
getDocumentById docId = do
  index <- getIndexName
  getDocumentById' index docId

getChangeById :: BH.DocId -> QueryM (Maybe EChange)
getChangeById = getDocumentById

getChangeEventById :: BH.DocId -> QueryM (Maybe EChangeEvent)
getChangeEventById = getDocumentById

getCrawlerMetadataDocId :: Text -> Text -> Text -> BH.DocId
getCrawlerMetadataDocId crawlerName crawlerType crawlerTypeValue =
  BH.DocId . Text.replace "/" "@" $
    Text.intercalate
      "-"
      [ crawlerName,
        crawlerType,
        crawlerTypeValue
      ]

getChangesByURL ::
  -- | List of URLs
  [Text] ->
  BH.Query
getChangesByURL urls = query
  where
    query =
      mkAnd
        [ BH.TermQuery (BH.Term "type" $ from EChangeDoc) Nothing,
          BH.TermsQuery "url" $ fromList urls
        ]

getChangesEventsByURL ::
  -- | List of URLs
  [Text] ->
  BH.Query
getChangesEventsByURL urls = query
  where
    query =
      mkAnd
        [ BH.TermsQuery "type" $ fromList eventTypesAsText,
          BH.TermsQuery "url" $ fromList urls
        ]

type HashTable k v = H.BasicHashTable k v

data TaskDataDoc = TaskDataDoc
  { tddId :: LText,
    tddTd :: [ETaskData]
  }
  deriving (Show)

type TaskDataOrphanDoc = TaskDataDoc

getOrphanTaskDataByChangeURL :: [Text] -> QueryM [EChangeOrphanTD]
getOrphanTaskDataByChangeURL urls = do
  index <- getIndexName
  results <- scanSearch index
  pure $ catMaybes $ BH.hitSource <$> results
  where
    scanSearch :: (MonadBH m, MonadThrow m) => BH.IndexName -> m [BH.Hit EChangeOrphanTD]
    scanSearch index = BH.scanSearch index search
    search = BH.mkSearch (Just query) Nothing
    query =
      mkAnd
        [ mkNot [BH.QueryExistsQuery $ BH.FieldName "tasks_data._adopted"],
          mkAnd
            [ BH.TermQuery (BH.Term "type" $ from EOrphanTaskData) Nothing,
              BH.TermsQuery "tasks_data.change_url" $ fromList urls
            ]
        ]

getOrphanTaskDataAndDeclareAdoption :: [Text] -> QueryM [EChangeOrphanTD]
getOrphanTaskDataAndDeclareAdoption urls = do
  oTDs <- getOrphanTaskDataByChangeURL urls
  void $ updateDocs $ toAdoptedDoc <$> oTDs
  pure oTDs
  where
    toAdoptedDoc :: EChangeOrphanTD -> (Value, BH.DocId)
    toAdoptedDoc (EChangeOrphanTD id' _ _) =
      ( toJSON $ EChangeOrphanTDAdopted id' EOrphanTaskData $ ETaskDataAdopted "",
        BH.DocId id'
      )

updateChangesAndEventsFromOrphanTaskData :: [EChange] -> [EChangeEvent] -> QueryM ()
updateChangesAndEventsFromOrphanTaskData changes events = do
  let mapping = uMapping Map.empty getFlatMapping
  adoptedTDs <- getOrphanTaskDataAndDeclareAdoption $ toText <$> Map.keys mapping
  updateDocs $ taskDataDocToBHDoc <$> getTaskDatas adoptedTDs (Map.assocs mapping)
  where
    -- For each change and event extract (changeUrl, object ID)
    getFlatMapping :: [(LText, LText)]
    getFlatMapping =
      ((\c -> (echangeUrl c, echangeId c)) <$> changes)
        <> ((\c -> (echangeeventUrl c, echangeeventId c)) <$> events)
    -- Create a Map where each key (changeUrl) maps a list of object ID
    uMapping :: Map LText [LText] -> [(LText, LText)] -> Map LText [LText]
    uMapping cM fm = case fm of
      [] -> cM
      (x : xs) -> let nM = Map.alter (updateE $ snd x) (fst x) cM in uMapping nM xs
      where
        updateE nE cEs = Just $ maybe [nE] (<> [nE]) cEs
    -- Gather TasksData from matching adopted TD object and create [TaskDataDoc]
    -- for Changes and Events
    getTaskDatas :: [EChangeOrphanTD] -> [(LText, [LText])] -> [TaskDataDoc]
    getTaskDatas adopted assocs = concatMap getTDs assocs
      where
        getTDs :: (LText, [LText]) -> [TaskDataDoc]
        getTDs (url, ids) =
          let mTDs = echangeorphantdTasksData <$> filterByUrl url adopted
           in flip TaskDataDoc mTDs <$> ids
        filterByUrl url = filter (\td -> tdChangeUrl (echangeorphantdTasksData td) == toText url)

taskDataDocToBHDoc :: TaskDataDoc -> (Value, BH.DocId)
taskDataDocToBHDoc TaskDataDoc {..} =
  (toJSON $ EChangeTD $ Just tddTd, BH.DocId $ toText tddId)

orphanTaskDataDocToBHDoc :: TaskDataDoc -> (Value, BH.DocId)
orphanTaskDataDocToBHDoc TaskDataDoc {..} =
  let td = head $ fromList tddTd
   in ( toJSON $
          EChangeOrphanTD
            (toText tddId)
            EOrphanTaskData
            td,
        BH.DocId $ toText tddId
      )

taskDataAdd :: Text -> [TaskData] -> QueryM ()
taskDataAdd crawlerName tds = do
  -- extract change URLs from input TDs
  let urls = toText . taskDataChangeUrl <$> tds
  -- get changes that matches those URLs
  changes <- runScanSearch $ getChangesByURL urls
  -- get change events that matches those URLs
  changeEvents <- runScanSearch $ getChangesEventsByURL urls
  -- Init the HashTable that we are going to use as a facility for processing
  changesHT <- liftIO $ initHT changes
  -- Update the HashTable based on incomming TDs and return orphan TDs
  orphanTaskDataDocs <- liftIO $ updateChangesWithTD changesHT
  -- Get TDs from the HashTable
  taskDataDocs <- fmap snd <$> liftIO (H.toList changesHT)
  -- Get the TDs form matching change events
  taskDataDocs' <-
    liftIO $
      fmap catMaybes <$> sequence $
        getTDforEventFromHT changesHT <$> changeEvents
  -- Let's push the data
  updateDocs (taskDataDocToBHDoc <$> taskDataDocs <> taskDataDocs')
  upsertDocs (orphanTaskDataDocToBHDoc <$> orphanTaskDataDocs)
  where
    initHT :: [EChange] -> IO (HashTable LText TaskDataDoc)
    initHT changes = H.fromList $ getMCsTuple <$> changes
      where
        getMCsTuple EChange {echangeUrl, echangeId, echangeTasksData} =
          (echangeUrl, TaskDataDoc echangeId (fromMaybe [] echangeTasksData))

    updateChangesWithTD ::
      -- | The local cache in form of HashMap
      HashTable LText TaskDataDoc ->
      -- | IO action with the list of orphan Task Data
      IO [TaskDataOrphanDoc]
    updateChangesWithTD ht = catMaybes <$> traverse handleTD (toETaskData crawlerName <$> tds)
      where
        handleTD ::
          -- | The input Task Data we want to append or update
          ETaskData ->
          -- | IO Action with maybe an orphan task data if a matching change does not exists
          IO (Maybe TaskDataOrphanDoc)
        handleTD td = H.mutate ht (toLazy $ tdChangeUrl td) $ \case
          -- Cannot find a change matching this TD -> this TD will be orphan
          Nothing -> (Nothing, Just $ TaskDataDoc {tddId = urlToId $ tdUrl td <> tdChangeUrl td, tddTd = [td]})
          -- Found a change matching this TD -> update existing TDs with new TD
          Just taskDataDoc -> (Just $ updateTDD taskDataDoc td, Nothing)
          where
            urlToId = toLazy . getBase64Text

        updateTDD ::
          -- | The value of the HashMap we are working on
          TaskDataDoc ->
          -- | The input Task Data we want to append or update
          ETaskData ->
          TaskDataDoc
        updateTDD taskDataDoc td = do
          let changeTDs = tddTd taskDataDoc
              -- The td has been updated so we remove any previous instance
              isOldTD td' = tdUrl td' == tdUrl td
              -- And we cons the new td.
              currentTDs = td : filter (not . isOldTD) changeTDs
           in taskDataDoc {tddTd = currentTDs}

    getTDforEventFromHT ::
      -- | The local cache in form of HashMap
      HashTable LText TaskDataDoc ->
      -- | The ChangeEvent to look for
      EChangeEvent ->
      -- | IO Action returning maybe a TaskData
      IO (Maybe TaskDataDoc)
    getTDforEventFromHT ht changeEvent = do
      mcM <- H.lookup ht $ echangeeventUrl changeEvent
      pure $ case mcM of
        Nothing -> Nothing
        Just mc -> Just $ TaskDataDoc {tddId = echangeeventId changeEvent, tddTd = tddTd mc}

type EntityType = CrawlerPB.EntityEntity

getWorkerName :: Config.Crawler -> Text
getWorkerName Config.Crawler {..} = name

getWorkerUpdatedSince :: Config.Crawler -> UTCTime
getWorkerUpdatedSince Config.Crawler {..} =
  fromMaybe
    (error "Invalid date format: Expected format YYYY-mm-dd or YYYY-mm-dd hh:mm:ss UTC")
    $ parseDateValue (toString update_since)

crawlerMDQuery :: EntityType -> Text -> BH.Query
crawlerMDQuery entity crawlerName =
  mkAnd
    [ BH.TermQuery (BH.Term "crawler_metadata.crawler_name" crawlerName) Nothing,
      BH.TermQuery (BH.Term "crawler_metadata.crawler_type" (getCrawlerTypeAsText entity)) Nothing
    ]

getLastUpdated :: Config.Crawler -> EntityType -> Word32 -> QueryM (Maybe (Text, UTCTime))
getLastUpdated crawler entity offset = do
  index <- getIndexName
  resp <- fmap BH.hitSource <$> simpleSearch index search
  case nonEmpty (catMaybes resp) of
    Nothing -> pure Nothing
    Just xs ->
      if length xs == from size
        then pure . Just $ getRespFromMetadata (last xs)
        else pure Nothing
  where
    size = offset + 1
    search =
      (BH.mkSearch (Just $ crawlerMDQuery entity crawlerName) Nothing)
        { BH.size = BH.Size $ from size,
          BH.sortBody = Just [BH.DefaultSortSpec bhSort]
        }

    bhSort = BH.DefaultSort (BH.FieldName "crawler_metadata.last_commit_at") BH.Ascending Nothing Nothing Nothing Nothing
    getRespFromMetadata (ECrawlerMetadata ECrawlerMetadataObject {..}) =
      (toStrict ecmCrawlerTypeValue, ecmLastCommitAt)
    crawlerName = getWorkerName crawler

-- | The following entityRequest are a bit bizarre, this is because we are re-using
-- the entity info response defined in protobuf. When requesting the last updated, we provide
-- an empty entity.
entityRequestProject, entityRequestOrganization, entityRequestTaskData :: CrawlerPB.EntityEntity
entityRequestProject = CrawlerPB.EntityEntityProjectName ""
entityRequestOrganization = CrawlerPB.EntityEntityOrganizationName ""
entityRequestTaskData = CrawlerPB.EntityEntityTdName ""

getCrawlerTypeAsText :: EntityType -> Text
getCrawlerTypeAsText entity' = case entity' of
  CrawlerPB.EntityEntityProjectName _ -> "project"
  CrawlerPB.EntityEntityOrganizationName _ -> "organization"
  CrawlerPB.EntityEntityTdName _ -> "taskdata"

ensureCrawlerMetadata :: Text -> QueryM UTCTime -> Entity -> QueryM ()
ensureCrawlerMetadata crawlerName getDate entity = do
  index <- getIndexName
  exists <- BH.documentExists index getId
  unless exists $ do
    lastUpdatedDate <- getDate
    withRefresh $ BH.indexDocument index BH.defaultIndexDocumentSettings (cm lastUpdatedDate) getId
  where
    cm lastUpdatedDate =
      ECrawlerMetadata
        { ecmCrawlerMetadata =
            ECrawlerMetadataObject
              (toLazy crawlerName)
              (from entity)
              (toLazy $ getEntityName entity)
              lastUpdatedDate
        }
    getId = getCrawlerMetadataDocId crawlerName (from entity) (getEntityName entity)

getMostRecentUpdatedChange :: QueryMonad m => Text -> m [EChange]
getMostRecentUpdatedChange fullname = do
  withFilter [mkTerm "repository_fullname" fullname] $ Q.changes (Just order) 1
  where
    order =
      Order
        { orderField = "updated_at",
          orderDirection = PT.Enumerated $ Right Order_DirectionDESC
        }

-- | Maybe return the most recent updatedAt date for a repository full name
getLastUpdatedDate :: QueryMonad m => Text -> m (Maybe UTCTime)
getLastUpdatedDate fullname = do
  recents <- getMostRecentUpdatedChange fullname
  pure $ case recents of
    [] -> Nothing
    (c : _) -> Just $ c & echangeUpdatedAt

setLastUpdated :: Text -> UTCTime -> Entity -> QueryM ()
setLastUpdated crawlerName lastUpdatedDate entity = do
  index <- getIndexName
  withRefresh $ BH.updateDocument index BH.defaultIndexDocumentSettings cm getId
  where
    getId = getCrawlerMetadataDocId crawlerName (from entity) (getEntityName entity)
    cm =
      ECrawlerMetadata
        { ecmCrawlerMetadata =
            ECrawlerMetadataObject
              (toLazy crawlerName)
              (from entity)
              (toLazy $ getEntityName entity)
              lastUpdatedDate
        }

initCrawlerEntities :: [Entity] -> Config.Crawler -> QueryM ()
initCrawlerEntities entities worker = traverse_ run entities
  where
    run :: Entity -> QueryM ()
    run entity = do
      let updated_since =
            fromMaybe defaultUpdatedSince <$> case entity of
              Project name -> getLastUpdatedDate $ fromMaybe "" (Config.getPrefix worker) <> name
              _ -> pure Nothing
      ensureCrawlerMetadata (getWorkerName worker) updated_since entity
    defaultUpdatedSince = getWorkerUpdatedSince worker

getProjectEntityFromCrawler :: Config.Crawler -> [Entity]
getProjectEntityFromCrawler worker = Project <$> Config.getCrawlerProject worker

getOrganizationEntityFromCrawler :: Config.Crawler -> [Entity]
getOrganizationEntityFromCrawler worker = Organization <$> Config.getCrawlerOrganization worker

getTaskDataEntityFromCrawler :: Config.Crawler -> [Entity]
getTaskDataEntityFromCrawler worker = TaskDataEntity <$> Config.getCrawlerTaskData worker

initCrawlerMetadata :: Config.Crawler -> QueryM ()
initCrawlerMetadata crawler =
  initCrawlerEntities
    ( getProjectEntityFromCrawler crawler
        <> getOrganizationEntityFromCrawler crawler
        <> getTaskDataEntityFromCrawler crawler
    )
    crawler
