import { h } from "preact";
import { useEffect } from "preact/hooks";

interface Client {
  id: number;
  name: string;
  email: string;
}

interface ClientTableProps {
  clients: Client[];
  onUpdate: (client: Client) => void;
  onDelete: (client: Client) => void;
}

export function ClientTable({ clients, onUpdate, onDelete }: ClientTableProps) {
  return (
    <div>
      <h2>Clients</h2>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {clients.map((client) => (
            <tr key={client.id}>
              <td>{client.id}</td>
              <td>{client.name}</td>
              <td>{client.email}</td>
              <td>
                <button onClick={() => onUpdate(client)}>Update</button>
                <button onClick={() => onDelete(client)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
