//= require active_admin/base
//= require active_admin/base

function updateSubcategories(select) {
    var selectedCategoryId = select.value;
    var subcategorySelect = document.getElementById("course_subcategory_id");
    var subcategoryOptions = subcategorySelect.options;
  
    Rails.ajax({
      url: '/admin/courses/' + selectedCategoryId + '/get_subcategories',
      type: 'json',
      success: function(data) {
        subcategorySelect.disabled = false;
        subcategoryOptions.length = 0;
  
        data.forEach(function(subcategory) {
          var option = new Option(subcategory[0], subcategory[1]);
          subcategoryOptions.add(option);
        });
  
        if (subcategoryOptions.length === 0) {
          subcategorySelect.disabled = true;
          var blankOption = new Option('No subcategories available', '');
          subcategoryOptions.add(blankOption);
        }
      }
    });
  }
  
  document.addEventListener('DOMContentLoaded', function() {
    var categorySelect = document.getElementById('course_category_id');
  
    if (categorySelect) {
      categorySelect.addEventListener('change', function() {
        updateSubcategories(this);
      });
  
      updateSubcategories(categorySelect);
    }
  });
  