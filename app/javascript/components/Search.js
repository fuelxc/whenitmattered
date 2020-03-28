import React from "react"
import PropTypes from "prop-types"
import {asyncContainer, Typeahead} from 'react-bootstrap-typeahead';

const AsyncTypeahead = asyncContainer(Typeahead);

class Search extends React.Component {
  state = {
    query: '',
    location: '',
    latitude: undefined,
    longitude: undefined,
    isLoading: false,
    id: '',
    options: []
  }

  handleInputChange = () => {
    this.setState({
      query: this.search.value
    })
  }

  render () {
    return (
      <React.Fragment>
        <AsyncTypeahead
          id={this.state.id}
          isLoading={this.state.isLoading}
          labelKey={option => `${option.name}`}
          onSearch={(query) => {
            this.setState({isLoading: true});
            fetch(`businesses.json?q=${query}`)
              .then(resp => resp.json())
              .then(json => this.setState({
                isLoading: false,
                options: json,
              }));
          }}
          options={this.state.options}
        />
      </React.Fragment>
    );
  }
}

export default Search
