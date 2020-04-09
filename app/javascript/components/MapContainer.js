import React from "react"
import PropTypes from "prop-types"

import {Map, InfoWindow, Marker} from 'google-maps-react';

export class MapContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
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

  markers = () => {
    return this.props.locations.map((location, _) => 
      <Marker name={location.display_name}
        key={location.id}
        address={location.address}
        notes={location.notes}
        url={location.url}
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
    if (!this.state.selectedPlace.notes) {
      return this.state.selectedPlace.articles.map((article, _) =>
        <p key={article.id}><a href={article.url} target="_new">{article.headline}</a></p>
      )
    } else {
      return <p>{this.state.selectedPlace.notes}</p>
    }
  }

  render() {

    return (
      <Map google={window.google}
           mapTypeControl={false}
           streetViewControl={false}
           fullscreenControl={false}
           zoom={14} 
           className="w-100 h-75 mh-300" 
           initialCenter={this.props.initialCenter}
           onReady={this.props.onReady}
           onBounds_changed={this.props.handleBoundsChange}
           onClick={this.onMapClicked}
           clickableIcons={false}
           gestureHandling="cooperative"
           styles={[
            {
              "featureType": "poi.business",
              stylers: [{visibility: 'off'}]
            }
           ]}
      >
        {this.markers()}
        <InfoWindow
          marker={this.state.activeMarker}
          onClose={this.onInfoWindowClose}
          visible={this.state.showingInfoWindow}>
          <div>
            <h4><a href={this.state.selectedPlace.url} target="_new">{this.state.selectedPlace.name}</a></h4>
            <h6>{this.state.selectedPlace.address}</h6>
            {this.headlines()}
          </div>
        </InfoWindow>
      </Map>
    );
  }
}

export default MapContainer