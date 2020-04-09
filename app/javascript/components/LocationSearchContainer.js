import React from 'react';
import PropTypes from 'prop-types';
import LocationInput from './LocationInput';
import CategorySelect from './CategorySelect';

class LocationSearchContainer extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <section className="bg-dark p-2">
        <div className="container">
          <div className="row justify-content-md-center">
            <div className="col-sm-12 col-md-8">
              <div className="input-group input-group-lg">
                <CategorySelect categoryOptions={this.props.categoryOptions} onCategoryChange={this.props.onCategoryChange} />
                <LocationInput onLocationChange={this.props.onLocationChange} />
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
}

LocationSearchContainer.defaultProps = {
  onLocationChange: place => ({}),
  onCategoryChange: category => ({}),
  categoryOptions: []
}

LocationSearchContainer.propTypes = {
  onLocationChange: PropTypes.func,
  onCategoryChange: PropTypes.func,
  categoryOptions: PropTypes.array
}

export default LocationSearchContainer