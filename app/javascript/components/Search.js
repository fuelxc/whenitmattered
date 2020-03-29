import React from "react"
import PropTypes from "prop-types"

import MapContainer from './MapContainer';
import LocationSearchInput from './LocationSearchInput';

class Search extends React.Component {
  constructor(props) {
    super(props);
    this.state = { location: undefined, map: undefined };
  }

  placeChangeHandler = place => {
    this.state.map.setCenter(place.geometry.location);
    this.state.map.setZoom(14);
  }

  readyHandler = (mapProps, map) => {
    this.setState({map: map})
  }

  render () {
    return (
      <React.Fragment>
        <LocationSearchInput onPlaceChange={this.placeChangeHandler} />
        <MapContainer initialCenter={this.props.initialCenter} 
                      onReady={this.readyHandler}
        />
      </React.Fragment>
    )
  }
}
Search.defaultProps = {
  initialCenter: {
    lat: 33.4484, lng: -112.0740
  }
}
export default Search