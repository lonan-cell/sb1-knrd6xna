/*
  # Initial Schema Setup for AgriConnect

  1. New Tables
    - users
      - Basic user information and authentication
    - farmers
      - Specific information for farmers
    - buyers
      - Specific information for buyers
    - products
      - Available agricultural products
    - messages
      - Chat messages between users
    
  2. Security
    - RLS enabled on all tables
    - Policies for authenticated users
*/

-- Users table
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  email text UNIQUE NOT NULL,
  full_name text NOT NULL,
  user_type text NOT NULL CHECK (user_type IN ('farmer', 'buyer')),
  phone_number text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Farmers table
CREATE TABLE farmers (
  id uuid PRIMARY KEY REFERENCES users(id),
  location text NOT NULL,
  products_grown text[] NOT NULL,
  available_quantity jsonb NOT NULL DEFAULT '{}',
  farming_experience int,
  certification text[]
);

-- Buyers table
CREATE TABLE buyers (
  id uuid PRIMARY KEY REFERENCES users(id),
  company_name text,
  preferred_regions text[],
  interested_products text[],
  purchase_history jsonb DEFAULT '[]'
);

-- Products table
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  farmer_id uuid REFERENCES users(id),
  quantity float NOT NULL,
  unit text NOT NULL,
  price_per_unit float,
  available boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Messages table
CREATE TABLE messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id uuid REFERENCES users(id),
  receiver_id uuid REFERENCES users(id),
  content text NOT NULL,
  read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE farmers ENABLE ROW LEVEL SECURITY;
ALTER TABLE buyers ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can read their own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Public can read farmer profiles"
  ON farmers
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Public can read buyer profiles"
  ON buyers
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Public can view available products"
  ON products
  FOR SELECT
  TO authenticated
  USING (available = true);

CREATE POLICY "Users can read their messages"
  ON messages
  FOR SELECT
  TO authenticated
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);