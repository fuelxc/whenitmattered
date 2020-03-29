import React from "react"
import PropTypes from "prop-types"

import {Map, InfoWindow, Marker} from 'google-maps-react';

export class MapContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
      locations: [],
      activeMarker: {},
      selectedPlace: { articles: [] },
      showingInfoWindow: false
    };
  }

  onMarkerClick = (props, marker) =>
    this.setState({
      activeMarker: marker,
      selectedPlace: props,
      showingInfoWindow: true
    });

  onInfoWindowClose = () =>
    this.setState({
      activeMarker: null,
      showingInfoWindow: false
    });

  onMapClicked = () => {
    if (this.state.showingInfoWindow)
      this.setState({
        activeMarker: null,
        showingInfoWindow: false
      });
  };

  searchUrl = (bounds) => {
    let northEast = bounds.getNorthEast();
    let southWest = bounds.getSouthWest();

    return `/locations.json?tl_lat=${northEast.lat()}&tl_lon=${southWest.lng()}&br_lat=${southWest.lat()}&br_lon=${northEast.lng()}`
  }

  handleBoundsChange = (mapProps, map) => {
    fetch(this.searchUrl(map.getBounds()))
      .then(resp => resp.json())
      .then(json => this.setState({
        isLoading: false,
        locations: json,
      }));
  }

  markers = () => {
    return this.state.locations.map((location, _) => 
      <Marker name={location.display_name} 
        address={location.address}
        articles={location.articles}
        onClick={this.onMarkerClick}
        position={{
          lat: location.lat,
          lng: location.lon
        }}
      />
    )
  }

  headlines = () => {
    return this.state.selectedPlace.articles.map((article, ) =>
      <p><a href={article.url} target="_new">{article.headline}</a></p>
    )
  }

  render() {

    return (
      <Map google={window.google} 
           scrollwheel={false}
           mapTypeControl={false}
           streetViewControl={false}
           fullscreenControl={false}
           zoom={14} 
           className="vw-100 vh-100 mh-300" 
           initialCenter={this.props.initialCenter}
           onReady={this.props.onReady}
           onBounds_changed={this.handleBoundsChange}
           onClick={this.onMapClicked}
      >
        {this.markers()}
        <InfoWindow
          marker={this.state.activeMarker}
          onClose={this.onInfoWindowClose}
          visible={this.state.showingInfoWindow}>
          <div>
            <h4>{this.state.selectedPlace.name}</h4>
            <h6>{this.state.selectedPlace.address}</h6>
            {this.headlines()}
          </div>
        </InfoWindow>
      </Map>
    );
  }
}

export default MapContainer