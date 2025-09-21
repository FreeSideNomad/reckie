-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create initial tables
CREATE TABLE IF NOT EXISTS requirements (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for vector similarity search
CREATE INDEX IF NOT EXISTS requirements_embedding_idx ON requirements
USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Insert sample data
INSERT INTO requirements (title, description) VALUES
('Hello World Requirement', 'Basic requirement for testing the system setup');