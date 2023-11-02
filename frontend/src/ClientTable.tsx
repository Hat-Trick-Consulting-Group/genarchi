import { h } from "preact";
import { useEffect, useState } from "preact/hooks";
import { ClientUpdate } from "./ClientUpdate";

interface Client {
  id: number;
  name: string;
  email: string;
}

interface ClientTableProps {
  clients: Client[];
  onRefresh: () => void;
  onUpdate: (client: Client) => void;
  onDelete: (client: Client) => void;
}

export function ClientTable({ clients, onRefresh, onUpdate, onDelete }: ClientTableProps) {
  const [isUpdateVisible, setIsUpdateVisible] = useState(false);
  const [selectedClient, setSelectedClient] = useState(null);

  const handleUpdateClick = (client) => {
    setSelectedClient(client);
    setIsUpdateVisible(true);
  };

  return (
    <div>
      <h2>Clients</h2>
      <button onClick={() => onRefresh()}>Refresh</button>
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
          {clients
            ? clients.map((client) => (
                <tr key={client.id}>
                  <td>{client.id}</td>
                  <td>{client.name}</td>
                  <td>{client.email}</td>
                  <td>
                    <button onClick={() => handleUpdateClick(client)}>Update</button>
                    <button onClick={() => onDelete(client)}>Delete</button>
                  </td>
                </tr>
              ))
            : "no clients"}
        </tbody>
      </table>
      {isUpdateVisible && (
        <div>
          <h3>Update Client</h3>
          <ClientUpdate
            client={selectedClient}
            onUpdate={(updatedClient) => {
              onUpdate(updatedClient);
              setIsUpdateVisible(false);
            }}
          />
        </div>
      )}
    </div>
  );
}
