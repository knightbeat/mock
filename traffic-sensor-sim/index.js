const express = require("express");
const app = express();

const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");

const swaggerDocument = YAML.load("./swagger.yaml");
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

const PORT = 3000;

// Defaults
const DEFAULT_DEVICE_ID = "edge-5g-traffic-001";
const DEFAULT_LOCATION = {
  lat: 51.5074,
  lon: -0.1278,
  road: "A501",
  lane: 2
};

// Helpers
const random = (min, max) => Math.random() * (max - min) + min;

const isRushHour = () => {
  const hour = new Date().getHours();
  return (hour >= 7 && hour <= 9) || (hour >= 16 && hour <= 18);
};

function generateTrafficSensorData({ deviceId, road, lane }) {
  const rushFactor = isRushHour() ? 1.6 : 1.0;

  const vehicleCount = Math.floor(random(5, 15) * rushFactor);
  const avgSpeed = Math.max(20, random(35, 70) / rushFactor);

  return {
    deviceId,
    timestamp: new Date().toISOString(),
    location: {
      ...DEFAULT_LOCATION,
      road,
      lane
    },
    traffic: {
      vehicleCount,
      avgSpeedKmph: Number(avgSpeed.toFixed(1)),
      occupancyPct: Math.min(100, vehicleCount * 4),
      vehicles: {
        car: Math.floor(vehicleCount * 0.75),
        bus: Math.floor(vehicleCount * 0.1),
        truck: Math.floor(vehicleCount * 0.1),
        bike: Math.max(0, vehicleCount - Math.floor(vehicleCount * 0.95))
      }
    },
    network: {
      edge: true,
      signalStrengthDbm: Math.floor(random(-90, -60)),
      latencyMs: Math.floor(random(5, 15))
    }
  };
}

// REST endpoint with query params
app.get("/api/traffic-sensor", (req, res) => {
  const {
    deviceId = "edge-5g-traffic-001",
    road = "A501",
    lane = 2,
    lat = 51.5074,
    lon = -0.1278
  } = req.query;

  const rushFactor = isRushHour() ? 1.6 : 1.0;
  const vehicleCount = Math.floor(random(5, 15) * rushFactor);
  const avgSpeed = Math.max(20, random(35, 70) / rushFactor);

  res.json({
    deviceId,
    timestamp: new Date().toISOString(),
    location: {
      lat: Number(lat),
      lon: Number(lon),
      road,
      lane: Number(lane)
    },
    traffic: {
      vehicleCount,
      avgSpeedKmph: Number(avgSpeed.toFixed(1)),
      occupancyPct: Math.min(100, vehicleCount * 4),
      vehicles: {
        car: Math.floor(vehicleCount * 0.75),
        bus: Math.floor(vehicleCount * 0.1),
        truck: Math.floor(vehicleCount * 0.1),
        bike: Math.max(0, vehicleCount - Math.floor(vehicleCount * 0.95))
      }
    },
    network: {
      edge: true,
      signalStrengthDbm: Math.floor(random(-90, -60)),
      latencyMs: Math.floor(random(5, 15))
    }
  });
});

// Health check (optional but useful)
app.get("/health", (_, res) => res.send("OK"));

app.listen(PORT, () => {
  console.log(`Traffic sensor REST API running on port ${PORT}`);
});
