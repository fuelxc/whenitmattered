import React from 'react';
import PropTypes from 'prop-types';

class LocationSearchInput extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    if (!window.google) {
      throw new Error(
        '[react-places-autocomplete]: Google Maps JavaScript API library must be loaded. See: https://github.com/kenny-hibino/react-places-autocomplete#load-google-library'
      );
    }

    if (!window.google.maps.places) {
      throw new Error(
        '[react-places-autocomplete]: Google Maps Places library must be loaded. Please add `libraries=places` to the src URL. See: https://github.com/kenny-hibino/react-places-autocomplete#load-google-library'
      );
    }

    this.input = document.getElementById('locationInput');
    this.autocomplete = new google.maps.places.Autocomplete(this.input);
    this.autocomplete.setFields(
        ['address_components', 'geometry', 'icon', 'name']);
    
    this.autocomplete.setTypes(['(regions)']);

    let { onPlaceChange } = this.props;

    this.autocomplete.addListener('place_changed', function() {
      onPlaceChange(this.getPlace());
    });
  }

  render() {
    return (
      <section className="bg-dark p-2">
        <div className="container">
          <div className="row justify-content-md-center">
            <div className="col-sm-12 col-md-6">
              <div className="input-group input-group-lg">
                <input id="locationInput" className='form-control' placeholder="Search by Location..." />
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
}

LocationSearchInput.defaultProps = {
  onPlaceChange: place => ({})
}

LocationSearchInput.propTypes = {
  onPlaceChange: PropTypes.func
}


export default LocationSearchInput