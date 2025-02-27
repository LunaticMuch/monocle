open Prelude

module PieWithLegend = {
  type entry = {
    key: string,
    doc_count: int,
  }
  type t = {
    items: array<entry>,
    total_hits: int,
  }
  type named_palette_t = {
    "APPROVED": string,
    "CHANGES_REQUESTED": string,
    "COMMENTED": string,
    "Code-Review+1": string,
    "Code-Review+2": string,
    "Code-Review-1": string,
    "Code-Review-2": string,
    "DISMISSED": string,
    "Workflow+1": string,
    "Workflow-1": string,
  }

  let getColorFromNamedPalette = (label: string, namedPalette: named_palette_t): option<string> => {
    switch label {
    | "APPROVED" => namedPalette["APPROVED"]->Some
    | "CHANGES_REQUESTED" => namedPalette["CHANGES_REQUESTED"]->Some
    | "COMMENTED" => namedPalette["COMMENTED"]->Some
    | "Code-Review+1" => namedPalette["Code-Review+1"]->Some
    | "Code-Review+2" => namedPalette["Code-Review+2"]->Some
    | "Code-Review-1" => namedPalette["Code-Review-1"]->Some
    | "Code-Review-2" => namedPalette["Code-Review-2"]->Some
    | "DISMISSED" => namedPalette["DISMISSED"]->Some
    | "Workflow+1" => namedPalette["Workflow+1"]->Some
    | "Workflow-1" => namedPalette["Workflow-1"]->Some
    | _ => None
    }
  }

  let defaultPalette = [
    "#247ba0",
    "#70c1b3",
    "#b2dbbf",
    "#f3ffbd",
    "#ff1654",
    "#247ba0",
    "#70c1b3",
    "#b2dbbf",
    "#f3ffbd",
    "#ff1654",
    "#b2dbbf",
  ]

  let getColorFromPalette = (index: int, label: string, namedPaletteM: option<named_palette_t>) => {
    let getFromDefaultPalette = (i: int) =>
      switch defaultPalette->Belt.Array.get(i) {
      | Some(color) => color
      | None => "black"
      }
    switch namedPaletteM {
    | Some(namedPalette) =>
      switch getColorFromNamedPalette(label, namedPalette) {
      | Some(color) => color
      | None => getFromDefaultPalette(index)
      }
    | None => getFromDefaultPalette(index)
    }
  }

  module PieChart = {
    @react.component @module("./chartjs.jsx")
    external make: (
      ~data: t,
      ~palette: array<string>,
      ~namedPalette: named_palette_t=?,
      ~handleClick: (~value: string) => unit,
      ~other_label: string=?,
    ) => React.element = "PieChart"
  }

  module PieChartLegend = {
    @react.component
    let make = (
      ~data: t,
      ~namedPalette: option<named_palette_t>,
      ~handleClick: (~value: string) => unit,
    ) => {
      data.items
      ->Belt.Array.mapWithIndex((i, e) =>
        <div key={e.key}>
          <span
            style={ReactDOM.Style.make(
              ~backgroundColor={getColorFromPalette(i, e.key, namedPalette)},
              ~width="10px",
              ~height="10px",
              ~display="inline-block",
              ~cursor="pointer",
              (),
            )}
          />
          <span> {" "->str} </span>
          <span
            key={e.key}
            onClick={_ => handleClick(~value=e.key)}
            style={ReactDOM.Style.make(~cursor="pointer", ())}>
            {e.key->str}
          </span>
        </div>
      )
      ->React.array
    }
  }

  @react.component
  let make = (
    ~data: t,
    ~title: string,
    ~handleClick: (~value: string) => unit,
    ~namedPalette: option<named_palette_t>=?,
    ~other_label: option<string>=?,
  ) => {
    <React.Fragment>
      <Patternfly.Card isCompact={true}>
        <Patternfly.CardTitle>
          <Patternfly.Title headingLevel=#H3> {title->str} </Patternfly.Title>
        </Patternfly.CardTitle>
        <Patternfly.CardBody>
          <PieChart data palette={defaultPalette} handleClick ?namedPalette ?other_label />
          <PieChartLegend data namedPalette handleClick />
        </Patternfly.CardBody>
      </Patternfly.Card>
    </React.Fragment>
  }
}

module ChangeList = {
  @react.component
  let make = (
    ~store: Store.t,
    ~changes: HiddenChanges.changeArray,
    ~dispatchChange: HiddenChanges.dispatch,
  ) => {
    let (toggle, isChangeVisible) = HiddenChanges.useToggle()
    let (changesArray, paginate) = usePagination(changes)
    <>
      {toggle}
      {paginate}
      <br />
      <Patternfly.DataList isCompact={true}>
        {changesArray
        ->Belt.Array.map(((status, change)) =>
          isChangeVisible(status)
            ? <Change.DataItem store key={change.change_id} change status dispatchChange />
            : React.null
        )
        ->React.array}
      </Patternfly.DataList>
    </>
  }
}

module ChangesTopPies = {
  @react.component
  let make = (~store) => {
    let (state, dispatch) = store
    let qtype = SearchTypes.Query_changes_tops
    let request = {
      ...Store.mkSearchRequest(state, qtype),
      limit: 10->Int32.of_int,
      query: addQuery(state.query, state.filter),
    }
    let query = request.query
    let getEntry = (e: SearchTypes.term_count): PieWithLegend.entry => {
      doc_count: e.count->Int32.to_int,
      key: e.term,
    }
    let adapt = (
      elms: SearchTypes.terms_count,
      kf: PieWithLegend.entry => bool,
    ): PieWithLegend.t => {
      items: elms.termcount->Belt.List.map(getEntry)->Belt.List.keep(kf)->Belt.List.toArray,
      total_hits: elms.total_hits->Int32.to_int,
    }
    let tee = (_: bool => bool) => Store.Store.ReverseChangesPiePanelState->dispatch
    let approvals_palette = {
      "Code-Review+2": "#00ff9f",
      "Code-Review+1": "#B6FCD5",
      "Code-Review-1": "#CA5462",
      "Code-Review-2": "#AB0000",
      "Workflow+1": "#00ff9f",
      "Workflow-1": "#AB0000",
      "APPROVED": "#00ff9f",
      "DISMISSED": "#AB0000",
      "COMMENTED": "#B6FCD5",
      "CHANGES_REQUESTED": "#CA5462",
    }
    let ignoredApproval = ["Code-Review+0", "Verified+0", "Workflow+0", "COMMENTED"]
    let handlePieClick = (state: Store.Store.t, dispatch, ~field: string, ~value: string) => {
      let newFilter = field ++ ":\"" ++ value ++ "\""
      let filter = Js.String.includes(newFilter, state.filter)
        ? state.filter
        : addQuery(state.filter, newFilter)
      let base = "/" ++ state.index ++ "/" ++ "changes" ++ "?"
      let query = switch state.query {
      | "" => ""
      | query => "q=" ++ query ++ "&"
      }
      let href = base ++ query ++ "f=" ++ filter
      filter->Store.Store.SetFilter->dispatch
      href->RescriptReactRouter.push
    }
    <QueryRender
      request
      trigger={query}
      render={resp =>
        switch resp {
        | SearchTypes.Changes_tops(items) =>
          <MExpandablePanel
            title={"Show changes pie charts"} stateControler={(state.changes_pies_panel, tee)}>
            <MGrid>
              <MGridItemXl4>
                <PieWithLegend
                  data={items.authors->Belt.Option.getExn->adapt(_ => true)}
                  title={"Changes per author"}
                  handleClick={handlePieClick(state, dispatch, ~field="author")}
                />
              </MGridItemXl4>
              <MGridItemXl4>
                <PieWithLegend
                  data={items.repos->Belt.Option.getExn->adapt(_ => true)}
                  title={"Changes per repository"}
                  handleClick={handlePieClick(state, dispatch, ~field="repo")}
                />
              </MGridItemXl4>
              <MGridItemXl4>
                <PieWithLegend
                  data={items.approvals
                  ->Belt.Option.getExn
                  ->adapt(e => ignoredApproval->Belt.Array.some(e' => e' != e.key))}
                  title={"Changes per approval"}
                  handleClick={handlePieClick(state, dispatch, ~field="approval")}
                  namedPalette={approvals_palette}
                />
              </MGridItemXl4>
            </MGrid>
          </MExpandablePanel>
        | _ => <Alert title={"Invalid response"} />
        }}
    />
  }
}

module View = {
  @react.component
  let make = (~store: Store.t, ~changesAll) => {
    let (state, _) = store
    let (changes, dispatchChange) = HiddenChanges.use(state.dexie, changesAll)
    switch changes->Belt.Array.length {
    | 0 => <p> {"No changes matched"->str} </p>
    | _ =>
      <MStack>
        <MStackItem> <MCenteredContent> <ChangesTopPies store /> </MCenteredContent> </MStackItem>
        <MStackItem> <MCenteredContent> <Search.Filter store /> </MCenteredContent> </MStackItem>
        <MStackItem>
          <MCenteredContent> <ChangeList store changes dispatchChange /> </MCenteredContent>
        </MStackItem>
      </MStack>
    }
  }
}

@react.component
let make = (~store: Store.t) => {
  let (state, _) = store
  let query = addQuery(state.query, state.filter)
  let request = {
    ...Store.mkSearchRequest(state, SearchTypes.Query_change),
    query: query,
    limit: 256->Int32.of_int,
  }

  <div>
    <QueryRender
      request
      trigger={query ++ state.order->orderToQS}
      render={resp =>
        switch resp {
        | SearchTypes.Changes(items) => <View store changesAll={items.changes->Belt.List.toArray} />

        | _ => <Alert title={"Invalid response"} />
        }}
    />
  </div>
}

let default = make
