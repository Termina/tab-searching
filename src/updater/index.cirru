
= module.exports $ \ (store actionType actionData)
  case actionType
    :fetch-tabs
      store.set :tabs actionData
    :fetch-initial
      store.set :initial (actionData.get :id)
    :close-tab
      ... store
        update :tabs $ \ (tabs)
          tabs.filterNot $ \ (tab)
            is (tab.get :id) actionData
        update :pointer $ \ (pointer)
          cond (> pointer 0) (- pointer 1) 0
    :select-tab
      store.set :pointer pointer
    else store
