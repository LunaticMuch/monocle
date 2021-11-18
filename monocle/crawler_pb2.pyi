"""
@generated by mypy-protobuf.  Do not edit manually!
isort:skip_file
"""
import builtins
import google.protobuf.descriptor
import google.protobuf.internal.containers
import google.protobuf.internal.enum_type_wrapper
import google.protobuf.message
import google.protobuf.timestamp_pb2
import monocle.change_pb2
import monocle.project_pb2
import monocle.search_pb2
import typing
import typing_extensions

DESCRIPTOR: google.protobuf.descriptor.FileDescriptor = ...

class AddDocError(_AddDocError, metaclass=_AddDocErrorEnumTypeWrapper):
    pass

class _AddDocError:
    V = typing.NewType("V", builtins.int)

class _AddDocErrorEnumTypeWrapper(
    google.protobuf.internal.enum_type_wrapper._EnumTypeWrapper[_AddDocError.V],
    builtins.type,
):
    DESCRIPTOR: google.protobuf.descriptor.EnumDescriptor = ...
    AddUnknownIndex = AddDocError.V(0)
    AddUnknownCrawler = AddDocError.V(1)
    AddUnknownApiKey = AddDocError.V(2)
    AddFailed = AddDocError.V(3)

AddUnknownIndex = AddDocError.V(0)
AddUnknownCrawler = AddDocError.V(1)
AddUnknownApiKey = AddDocError.V(2)
AddFailed = AddDocError.V(3)
global___AddDocError = AddDocError

class CommitError(_CommitError, metaclass=_CommitErrorEnumTypeWrapper):
    pass

class _CommitError:
    V = typing.NewType("V", builtins.int)

class _CommitErrorEnumTypeWrapper(
    google.protobuf.internal.enum_type_wrapper._EnumTypeWrapper[_CommitError.V],
    builtins.type,
):
    DESCRIPTOR: google.protobuf.descriptor.EnumDescriptor = ...
    CommitUnknownIndex = CommitError.V(0)
    CommitUnknownCrawler = CommitError.V(1)
    CommitUnknownApiKey = CommitError.V(2)
    CommitDateInferiorThanPrevious = CommitError.V(3)
    CommitDateMissing = CommitError.V(4)

CommitUnknownIndex = CommitError.V(0)
CommitUnknownCrawler = CommitError.V(1)
CommitUnknownApiKey = CommitError.V(2)
CommitDateInferiorThanPrevious = CommitError.V(3)
CommitDateMissing = CommitError.V(4)
global___CommitError = CommitError

class CommitInfoError(_CommitInfoError, metaclass=_CommitInfoErrorEnumTypeWrapper):
    pass

class _CommitInfoError:
    V = typing.NewType("V", builtins.int)

class _CommitInfoErrorEnumTypeWrapper(
    google.protobuf.internal.enum_type_wrapper._EnumTypeWrapper[_CommitInfoError.V],
    builtins.type,
):
    DESCRIPTOR: google.protobuf.descriptor.EnumDescriptor = ...
    CommitGetUnknownIndex = CommitInfoError.V(0)
    CommitGetUnknownCrawler = CommitInfoError.V(1)
    CommitGetNoEntity = CommitInfoError.V(2)

CommitGetUnknownIndex = CommitInfoError.V(0)
CommitGetUnknownCrawler = CommitInfoError.V(1)
CommitGetNoEntity = CommitInfoError.V(2)
global___CommitInfoError = CommitInfoError

class Entity(google.protobuf.message.Message):
    """A descriptive name of the entities being added"""

    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    ORGANIZATION_NAME_FIELD_NUMBER: builtins.int
    PROJECT_NAME_FIELD_NUMBER: builtins.int
    TD_NAME_FIELD_NUMBER: builtins.int
    organization_name: typing.Text = ...
    project_name: typing.Text = ...
    td_name: typing.Text = ...
    def __init__(
        self,
        *,
        organization_name: typing.Text = ...,
        project_name: typing.Text = ...,
        td_name: typing.Text = ...,
    ) -> None: ...
    def HasField(
        self,
        field_name: typing_extensions.Literal[
            "entity",
            b"entity",
            "organization_name",
            b"organization_name",
            "project_name",
            b"project_name",
            "td_name",
            b"td_name",
        ],
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "entity",
            b"entity",
            "organization_name",
            b"organization_name",
            "project_name",
            b"project_name",
            "td_name",
            b"td_name",
        ],
    ) -> None: ...
    def WhichOneof(
        self, oneof_group: typing_extensions.Literal["entity", b"entity"]
    ) -> typing.Optional[
        typing_extensions.Literal["organization_name", "project_name", "td_name"]
    ]: ...

global___Entity = Entity

class AddDocRequest(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    INDEX_FIELD_NUMBER: builtins.int
    CRAWLER_FIELD_NUMBER: builtins.int
    APIKEY_FIELD_NUMBER: builtins.int
    ENTITY_FIELD_NUMBER: builtins.int
    CHANGES_FIELD_NUMBER: builtins.int
    EVENTS_FIELD_NUMBER: builtins.int
    PROJECTS_FIELD_NUMBER: builtins.int
    TASK_DATAS_FIELD_NUMBER: builtins.int
    index: typing.Text = ...
    crawler: typing.Text = ...
    apikey: typing.Text = ...
    @property
    def entity(self) -> global___Entity: ...
    @property
    def changes(
        self,
    ) -> google.protobuf.internal.containers.RepeatedCompositeFieldContainer[
        monocle.change_pb2.Change
    ]:
        """changes are added when Entity is project_name"""
        pass
    @property
    def events(
        self,
    ) -> google.protobuf.internal.containers.RepeatedCompositeFieldContainer[
        monocle.change_pb2.ChangeEvent
    ]:
        """events are added when Entity is project_name"""
        pass
    @property
    def projects(
        self,
    ) -> google.protobuf.internal.containers.RepeatedCompositeFieldContainer[
        monocle.project_pb2.Project
    ]:
        """projects are added when Entity is organization_name"""
        pass
    @property
    def task_datas(
        self,
    ) -> google.protobuf.internal.containers.RepeatedCompositeFieldContainer[
        monocle.search_pb2.TaskData
    ]:
        """task_datas are added when Entity is td_name"""
        pass
    def __init__(
        self,
        *,
        index: typing.Text = ...,
        crawler: typing.Text = ...,
        apikey: typing.Text = ...,
        entity: typing.Optional[global___Entity] = ...,
        changes: typing.Optional[typing.Iterable[monocle.change_pb2.Change]] = ...,
        events: typing.Optional[typing.Iterable[monocle.change_pb2.ChangeEvent]] = ...,
        projects: typing.Optional[typing.Iterable[monocle.project_pb2.Project]] = ...,
        task_datas: typing.Optional[typing.Iterable[monocle.search_pb2.TaskData]] = ...,
    ) -> None: ...
    def HasField(
        self, field_name: typing_extensions.Literal["entity", b"entity"]
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "apikey",
            b"apikey",
            "changes",
            b"changes",
            "crawler",
            b"crawler",
            "entity",
            b"entity",
            "events",
            b"events",
            "index",
            b"index",
            "projects",
            b"projects",
            "task_datas",
            b"task_datas",
        ],
    ) -> None: ...

global___AddDocRequest = AddDocRequest

class AddDocResponse(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    ERROR_FIELD_NUMBER: builtins.int
    error: global___AddDocError.V = ...
    def __init__(
        self,
        *,
        error: global___AddDocError.V = ...,
    ) -> None: ...
    def HasField(
        self,
        field_name: typing_extensions.Literal["error", b"error", "result", b"result"],
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal["error", b"error", "result", b"result"],
    ) -> None: ...
    def WhichOneof(
        self, oneof_group: typing_extensions.Literal["result", b"result"]
    ) -> typing.Optional[typing_extensions.Literal["error"]]: ...

global___AddDocResponse = AddDocResponse

class CommitRequest(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    INDEX_FIELD_NUMBER: builtins.int
    CRAWLER_FIELD_NUMBER: builtins.int
    APIKEY_FIELD_NUMBER: builtins.int
    ENTITY_FIELD_NUMBER: builtins.int
    TIMESTAMP_FIELD_NUMBER: builtins.int
    index: typing.Text = ...
    crawler: typing.Text = ...
    apikey: typing.Text = ...
    @property
    def entity(self) -> global___Entity: ...
    @property
    def timestamp(self) -> google.protobuf.timestamp_pb2.Timestamp: ...
    def __init__(
        self,
        *,
        index: typing.Text = ...,
        crawler: typing.Text = ...,
        apikey: typing.Text = ...,
        entity: typing.Optional[global___Entity] = ...,
        timestamp: typing.Optional[google.protobuf.timestamp_pb2.Timestamp] = ...,
    ) -> None: ...
    def HasField(
        self,
        field_name: typing_extensions.Literal[
            "entity", b"entity", "timestamp", b"timestamp"
        ],
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "apikey",
            b"apikey",
            "crawler",
            b"crawler",
            "entity",
            b"entity",
            "index",
            b"index",
            "timestamp",
            b"timestamp",
        ],
    ) -> None: ...

global___CommitRequest = CommitRequest

class CommitResponse(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    ERROR_FIELD_NUMBER: builtins.int
    TIMESTAMP_FIELD_NUMBER: builtins.int
    error: global___CommitError.V = ...
    @property
    def timestamp(self) -> google.protobuf.timestamp_pb2.Timestamp: ...
    def __init__(
        self,
        *,
        error: global___CommitError.V = ...,
        timestamp: typing.Optional[google.protobuf.timestamp_pb2.Timestamp] = ...,
    ) -> None: ...
    def HasField(
        self,
        field_name: typing_extensions.Literal[
            "error", b"error", "result", b"result", "timestamp", b"timestamp"
        ],
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "error", b"error", "result", b"result", "timestamp", b"timestamp"
        ],
    ) -> None: ...
    def WhichOneof(
        self, oneof_group: typing_extensions.Literal["result", b"result"]
    ) -> typing.Optional[typing_extensions.Literal["error", "timestamp"]]: ...

global___CommitResponse = CommitResponse

class CommitInfoRequest(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    INDEX_FIELD_NUMBER: builtins.int
    CRAWLER_FIELD_NUMBER: builtins.int
    ENTITY_FIELD_NUMBER: builtins.int
    OFFSET_FIELD_NUMBER: builtins.int
    index: typing.Text = ...
    crawler: typing.Text = ...
    @property
    def entity(self) -> global___Entity:
        """the entity value is ignored"""
        pass
    offset: builtins.int = ...
    def __init__(
        self,
        *,
        index: typing.Text = ...,
        crawler: typing.Text = ...,
        entity: typing.Optional[global___Entity] = ...,
        offset: builtins.int = ...,
    ) -> None: ...
    def HasField(
        self, field_name: typing_extensions.Literal["entity", b"entity"]
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "crawler",
            b"crawler",
            "entity",
            b"entity",
            "index",
            b"index",
            "offset",
            b"offset",
        ],
    ) -> None: ...

global___CommitInfoRequest = CommitInfoRequest

class CommitInfoResponse(google.protobuf.message.Message):
    DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
    class OldestEntity(google.protobuf.message.Message):
        DESCRIPTOR: google.protobuf.descriptor.Descriptor = ...
        ENTITY_FIELD_NUMBER: builtins.int
        LAST_COMMIT_AT_FIELD_NUMBER: builtins.int
        @property
        def entity(self) -> global___Entity: ...
        @property
        def last_commit_at(self) -> google.protobuf.timestamp_pb2.Timestamp: ...
        def __init__(
            self,
            *,
            entity: typing.Optional[global___Entity] = ...,
            last_commit_at: typing.Optional[
                google.protobuf.timestamp_pb2.Timestamp
            ] = ...,
        ) -> None: ...
        def HasField(
            self,
            field_name: typing_extensions.Literal[
                "entity", b"entity", "last_commit_at", b"last_commit_at"
            ],
        ) -> builtins.bool: ...
        def ClearField(
            self,
            field_name: typing_extensions.Literal[
                "entity", b"entity", "last_commit_at", b"last_commit_at"
            ],
        ) -> None: ...
    ERROR_FIELD_NUMBER: builtins.int
    ENTITY_FIELD_NUMBER: builtins.int
    error: global___CommitInfoError.V = ...
    @property
    def entity(self) -> global___CommitInfoResponse.OldestEntity: ...
    def __init__(
        self,
        *,
        error: global___CommitInfoError.V = ...,
        entity: typing.Optional[global___CommitInfoResponse.OldestEntity] = ...,
    ) -> None: ...
    def HasField(
        self,
        field_name: typing_extensions.Literal[
            "entity", b"entity", "error", b"error", "result", b"result"
        ],
    ) -> builtins.bool: ...
    def ClearField(
        self,
        field_name: typing_extensions.Literal[
            "entity", b"entity", "error", b"error", "result", b"result"
        ],
    ) -> None: ...
    def WhichOneof(
        self, oneof_group: typing_extensions.Literal["result", b"result"]
    ) -> typing.Optional[typing_extensions.Literal["error", "entity"]]: ...

global___CommitInfoResponse = CommitInfoResponse
