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
    isLoading: false
  }

  handleInputChange = () => {
    this.setState({
      query: this.search.value
    })
  }

  searchUrl = (query) => {
    return `${this.props.url}?q=${query}`
  }

  render () {
    return (
      <React.Fragment>
        <AsyncTypeahead
          id={this.props.id}
          isLoading={this.state.isLoading}
          labelKey={option => `${option.name}`}
          bsSize='large'
          minLength={2}
          maxResults={20}
          placeholder={this.props.placeHolder}
          onSearch={(query) => {
            this.setState({isLoading: true});
            fetch(this.searchUrl(query))
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
