import React from 'react';
import PropTypes from 'prop-types';

class CategorySelect extends React.Component {
  constructor(props) {
    super(props);
  }

  categorySelectHandler = (e) => {
    this.props.onCategoryChange(e.target.value)
  }

  selectOptions = () => {
    return this.props.categoryOptions.map((option) => 
      <option key={option[0]} value={option[0]}>{option[1]}</option>
    )
  }

  render() {
    return (
      <select id="locationCategory" className="custom-select custom-select-lg" onChange={this.categorySelectHandler}>
        <option value=''>All Categories</option>
        {this.selectOptions()}
      </select>
    );
  }
}

CategorySelect.defaultProps = {
  onCategoryChange: category => ({}),
  categoryOptions: []
}

CategorySelect.propTypes = {
  onCategoryChange: PropTypes.func,
  categoryOptions: PropTypes.array
}

export default CategorySelect




