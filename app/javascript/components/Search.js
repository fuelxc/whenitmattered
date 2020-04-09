import React from "react"
import PropTypes from "prop-types"

import MapContainer from './MapContainer';
import LocationSearchContainer from './LocationSearchContainer';

class Search extends React.Component {
  constructor(props) {
    super(props);
    this.state = { location: undefined, map: undefined, category: '', locations: [] };
    this.categoryChangeHandler = this.categoryChangeHandler.bind(this)
    this.locationChangeHandler = this.locationChangeHandler.bind(this)
    this.readyHandler = this.readyHandler.bind(this)
    this.handleBoundsChange = this.handleBoundsChange.bind(this)
  }

  searchUrl = (bounds, category) => {
    let northEast = bounds.getNorthEast();
    let southWest = bounds.getSouthWest();
    let url = `/locations.json?tl_lat=${northEast.lat()}&tl_lon=${southWest.lng()}&br_lat=${southWest.lat()}&br_lon=${northEast.lng()}`
    if (!!(category)) {
      url = url + `&category=${category}`
    }
    return url
  }

  handleBoundsChange(mapProps, map) {
    this.fetchLocations(map, this.state.category);
  }

  fetchLocations(map, category) {
    fetch(this.searchUrl(map.getBounds(), category))
      .then(resp => resp.json())
      .then(json => this.setState({
        locations: json,
      }));
  }

  locationChangeHandler(place){
    this.state.map.setCenter(place.geometry.location);
    this.state.map.setZoom(14);
  }

  categoryChangeHandler(category) {
    this.setState({category: category});
    this.fetchLocations(this.state.map, category);
  }

  readyHandler(mapProps, map) {
    this.setState({map: map});
  }

  render () {
    return (
      <React.Fragment>
        <LocationSearchContainer onLocationChange={this.locationChangeHandler}
                             onCategoryChange={this.categoryChangeHandler}
                             categoryOptions={this.props.categoryOptions} />
        <MapContainer initialCenter={this.props.initialCenter}
                      intialCategory={this.state.category}       
                      onReady={this.readyHandler}
                      handleBoundsChange={this.handleBoundsChange}
                      locations={this.state.locations}
        />
      </React.Fragment>
    )
  }
}
Search.defaultProps = {
  initialCenter: {
    lat: 33.4484, lng: -112.0740
  },
  categoryOptions: [],
  searchBaseUrl: undefined
}
export default Search