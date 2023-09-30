import { h, render } from "preact";
import { ClientTable } from "./ClientTable";

export function App() {
  return (
    <div>
      <h1>Hat Trick</h1>
      <ClientTable />
    </div>
  );
}

render(<App />, document.getElementById("app"));
