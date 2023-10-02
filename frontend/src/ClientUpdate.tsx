import { h, Component } from "preact";

interface ClientUpdateProps {
  client: { id: number; name: string; email: string };
  onUpdate: (client: { id: number; name: string; email: string }) => void;
}

export class ClientUpdate extends Component<ClientUpdateProps> {
  state = {
    name: this.props.client.name,
    email: this.props.client.email,
  };

  handleInputChange = (event) => {
    const { name, value } = event.target;
    this.setState({ [name]: value });
  };

  handleSubmit = (event) => {
    event.preventDefault();

    if (this.props.onUpdate) {
      this.props.onUpdate({
        id: this.props.client.id,
        name: this.state.name,
        email: this.state.email,
      });
    }
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
          <button type="submit">Update Client</button>
        </div>
      </form>
    );
  }
}
