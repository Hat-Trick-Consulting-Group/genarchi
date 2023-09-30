import { h, Component } from "preact";

interface ClientAdditionProps {
  onSubmit: (client: { name: string; email: string }) => void;
}

export class ClientAddition extends Component<ClientAdditionProps> {
  state = {
    name: "",
    email: "",
  };

  handleInputChange = (event) => {
    const { name, value } = event.target;
    this.setState({ [name]: value });
  };

  handleSubmit = (event) => {
    event.preventDefault();

    if (this.props.onSubmit) {
      this.props.onSubmit({
        name: this.state.name,
        email: this.state.email,
      });
    }

    this.setState({ name: "", email: "" });
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div>
          <label>
            Name:
            <input type="text" name="name" value={this.state.name} onChange={this.handleInputChange} required />
          </label>
        </div>
        <div>
          <label>
            Email:
            <input type="email" name="email" value={this.state.email} onChange={this.handleInputChange} required />
          </label>
        </div>
        <div>
          <button type="submit">Add Client</button>
        </div>
      </form>
    );
  }
}
