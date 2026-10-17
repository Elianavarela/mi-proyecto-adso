CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Restricción de unicidad para correo
    CONSTRAINT uq_users_email UNIQUE (email),
    
    -- Restricción de dominio: solo roles autorizados
    CONSTRAINT chk_users_role CHECK (role IN ('admin', 'user'))
);


CREATE TABLE verification_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    token VARCHAR(64) NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Llave foránea estricta hacia users con eliminación en cascada
    CONSTRAINT fk_tokens_user FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,
        
    -- Token estrictamente único
    CONSTRAINT uq_tokens_token UNIQUE (token)
);