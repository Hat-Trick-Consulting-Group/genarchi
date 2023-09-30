import { h } from "preact";
import { useEffect, useState } from "preact/hooks";

interface Client {
  id: number;
  name: string;
  email: string;
}

export function ClientTable() {
  const API_URL = "http://localhost:8080/";

  const [clients, setClients] = useState<Client[]>([]);

  useEffect(() => {
    // Fetch data from your backend route
    fetch(API_URL + "get-clients")
      .then((response) => response.json())
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error fetching data:", error));
  }, []);

  return (
    <div>
      <h2>Clients</h2>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
          </tr>
        </thead>
        <tbody>
          {clients.map((client) => (
            <tr key={client.id}>
              <td>{client.id}</td>
              <td>{client.name}</td>
              <td>{client.email}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
