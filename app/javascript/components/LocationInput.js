import React from 'react';
import PropTypes from 'prop-types';

class LocationInput extends React.Component {
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

    let { onLocationChange } = this.props;

    this.autocomplete.addListener('place_changed', function() {
      onLocationChange(this.getPlace());
    });
  }

  render() {
    return (
      <input id="locationInput" className='form-control' placeholder="Search by Location..." />
    );
  }
}

LocationInput.defaultProps = {
  onLocationChange: place => ({})
}

LocationInput.propTypes = {
  onLocationChange: PropTypes.func
}

export default LocationInput