// Generated by CoffeeScript 2.5.0
(function() {
  var initComponents;

  initComponents = function() {
    var $item, _, component, componentName, componentsMap, i, item, len, ref, results;
    componentsMap = {};
    ref = $('[data-js-component]');
    for (i = 0, len = ref.length; i < len; i++) {
      item = ref[i];
      $item = $(item);
      componentsMap[$item.data('js-component')] = true;
    }
    results = [];
    for (componentName in componentsMap) {
      _ = componentsMap[componentName];
      component = window[componentName];
      console.log(`Initializing ${componentName}`);
      results.push(new component());
    }
    return results;
  };

  $(function() {
    return initComponents();
  });

}).call(this);
