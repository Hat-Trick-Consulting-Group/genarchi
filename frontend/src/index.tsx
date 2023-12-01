import { h, render } from "preact";
import { ClientTable } from "./ClientTable";
import { ClientAddition } from "./ClientAddition";
import { useState, useEffect } from "preact/hooks";
import { getClients, addClient, updateClient, deleteClient } from "./ClientServices"; // Import the service functions

export function App() {
  const [clients, setClients] = useState([]);

  useEffect(() => {
    handleGetClients();
  }, []);

  const handleGetClients = () => {
    getClients()
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error fetching clients:", error));
  };

  const handleAddClient = (newClient) => {
    addClient(newClient)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error adding client:", error));
  };

  const handleUpdateClient = (updatedClient) => {
    updateClient(updatedClient)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error updating client:", error));
  };

  const handleDeleteClient = (clientToDelete) => {
    deleteClient(clientToDelete)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error deleting client:", error));
  };

  const FRONTEND_IP = import.meta.env.VITE_FRONTEND_IP;

  return (
    <div>
      <h1>Hat Trick - Frontend Instance IP: {FRONTEND_IP}</h1>
      <ClientAddition onSubmit={handleAddClient} />
      <ClientTable clients={clients} onRefresh={handleGetClients} onUpdate={handleUpdateClient} onDelete={handleDeleteClient} />
    </div>
  );
}

render(<App />, document.getElementById("app"));
