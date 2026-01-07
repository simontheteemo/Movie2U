# E-Commerce Platform POC - Karivita New Zealand

## Project Overview

**Client:** Karivita New Zealand Limited

**Developer:** Miller Consulting Specialist Ltd

**Contract Date:** June 25, 2025

**Project Duration:** January 2026 - January 2027 (12 months)

---

## POC Objectives

The Proof of Concept phase aims to validate the technical feasibility and architectural decisions for the full-scale e-commerce platform before entering Phase 1 development.

### Primary Goals
- [ ] Validate AWS infrastructure setup (EC2/ECS, RDS, S3)
- [ ] Test core technology stack compatibility
- [ ] Demonstrate key user flows (browse, register, checkout)
- [ ] Validate payment gateway integration
- [ ] Confirm performance and scalability requirements
- [ ] Establish development workflow and CI/CD pipeline

---

## High-Level Architecture Overview

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              END USERS                                   │
│                     (Customers & Admin Users)                            │
└─────────────────────┬───────────────────────────────────────────────────┘
                      │
                      │ HTTPS
                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         FRONTEND LAYER                                   │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │  Web Application (React/Next.js/Vue.js)                          │  │
│  │  • Public Site (Product Catalog, Cart, Checkout)                 │  │
│  │  • User Dashboard (Profile, Order History)                       │  │
│  │  • Admin Panel (Product/Order/Customer Management)               │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────┘
                      │
                      │ REST API / GraphQL
                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         BACKEND LAYER (AWS)                              │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │  Application Server (Node.js/Python/Java)                        │  │
│  │  • API Gateway & Routes                                          │  │
│  │  • Business Logic & Services                                     │  │
│  │  • Authentication & Authorization                                │  │
│  │  • Payment Processing Integration                                │  │
│  │                                                                   │  │
│  │  Hosted on: EC2 / ECS / Fargate                                  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└─────────────────────┬───────────────────────────────────────────────────┘
                      │
                      │ Database Queries
                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       DATA LAYER (AWS)                                   │
│  ┌────────────────────────────┐    ┌──────────────────────────────┐    │
│  │  Primary Database          │    │  File Storage                │    │
│  │  (AWS RDS)                 │    │  (AWS S3)                    │    │
│  │  • PostgreSQL / MySQL      │    │  • Product Images            │    │
│  │  • Products                │    │  • Static Assets             │    │
│  │  • Users                   │    │  • User Uploads              │    │
│  │  • Orders                  │    │                              │    │
│  │  • Inventory               │    └──────────────────────────────┘    │
│  └────────────────────────────┘                                         │
│                                                                          │
│  ┌────────────────────────────┐                                         │
│  │  Cache Layer (Optional)    │                                         │
│  │  (Redis / ElastiCache)     │                                         │
│  │  • Session Management      │                                         │
│  │  • Performance Optimization│                                         │
│  └────────────────────────────┘                                         │
└──────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                    EXTERNAL INTEGRATIONS                                 │
│  ┌────────────────────────────┐    ┌──────────────────────────────┐    │
│  │  Payment Gateway           │    │  Email Service (Future)      │    │
│  │  • Stripe                  │    │  • AWS SES                   │    │
│  │  • PayPal                  │    │  • SendGrid                  │    │
│  └────────────────────────────┘    └──────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────┘
```

### User Flow Diagram

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         CUSTOMER JOURNEY                                  │
└──────────────────────────────────────────────────────────────────────────┘

1. BROWSE & DISCOVER
   ┌─────────────┐
   │ Landing Page│──▶ View Products ──▶ Search/Filter ──▶ Product Details
   └─────────────┘

2. AUTHENTICATION (Optional for Browsing)
   ┌──────────────┐
   │ Register/Login│──▶ Create Account ──▶ User Dashboard
   └──────────────┘

3. SHOPPING
   ┌──────────────┐
   │ Add to Cart  │──▶ Update Quantity ──▶ Review Cart
   └──────────────┘

4. CHECKOUT
   ┌──────────────┐
   │ Checkout     │──▶ Enter Details ──▶ Payment ──▶ Order Confirmation
   └──────────────┘

5. POST-PURCHASE
   ┌──────────────┐
   │ Order History│──▶ Track Order ──▶ View Status
   └──────────────┘


┌──────────────────────────────────────────────────────────────────────────┐
│                          ADMIN JOURNEY                                    │
└──────────────────────────────────────────────────────────────────────────┘

1. AUTHENTICATION
   ┌──────────────┐
   │ Admin Login  │──▶ Admin Dashboard
   └──────────────┘

2. PRODUCT MANAGEMENT
   ┌──────────────────┐
   │ Manage Products  │──▶ Add/Edit/Delete ──▶ Update Inventory
   └──────────────────┘

3. ORDER MANAGEMENT
   ┌──────────────────┐
   │ View Orders      │──▶ Update Status ──▶ Process Fulfillment
   └──────────────────┘

4. CUSTOMER MANAGEMENT
   ┌──────────────────┐
   │ View Customers   │──▶ View Details ──▶ Manage Accounts
   └──────────────────┘
```

### Data Flow Diagram

```
┌────────────┐         ┌────────────┐         ┌────────────┐
│            │         │            │         │            │
│   Client   │◀───────▶│   API      │◀───────▶│  Database  │
│  (Browser) │  HTTP   │   Server   │  SQL    │   (RDS)    │
│            │         │            │         │            │
└────────────┘         └─────┬──────┘         └────────────┘
                             │
                             │
                    ┌────────┴────────┐
                    │                 │
                    ▼                 ▼
              ┌────────────┐    ┌────────────┐
              │  Payment   │    │   S3       │
              │  Gateway   │    │  Storage   │
              │ (Stripe)   │    │  (Images)  │
              └────────────┘    └────────────┘
```

---

## Technology Stack (Proposed)

### Frontend
- **Framework:** TBD (e.g., React, Next.js, Vue.js)
- **UI Library:** TBD (e.g., Material-UI, Tailwind CSS, Ant Design)
- **State Management:** TBD (e.g., Redux, Context API, Zustand)

### Backend
- **Runtime/Language:** TBD (e.g., Node.js, Python, Java)
- **Framework:** TBD (e.g., Express, NestJS, Django, Spring Boot)
- **API Style:** REST / GraphQL

### Database
- **Primary Database:** PostgreSQL / MySQL (AWS RDS)
- **Caching:** Redis / ElastiCache (if needed)

### Infrastructure
- **Cloud Provider:** AWS
- **Compute:** EC2 / ECS / Fargate
- **Storage:** S3
- **Database:** RDS
- **CDN:** CloudFront (optional)

### Payment Gateway
- **Primary:** Stripe / PayPal
- **Alternative:** TBD

### DevOps
- **Version Control:** Git (GitHub/GitLab/Bitbucket)
- **CI/CD:** GitHub Actions / GitLab CI / Jenkins
- **Containerization:** Docker
- **Orchestration:** ECS / Kubernetes (optional)

---

## POC Scope & Features

### Must-Have Features for POC
1. **Product Catalog**
   - Display 5-10 sample products
   - Basic search and filter functionality
   - Product detail page

2. **User Authentication**
   - User registration
   - User login
   - Basic user profile

3. **Shopping Cart**
   - Add to cart
   - Update quantities
   - Remove items

4. **Checkout Flow**
   - Basic checkout form
   - Payment gateway integration test
   - Order confirmation

5. **Admin Panel (Basic)**
   - Admin login
   - Add/edit/delete products
   - View orders

### Out of Scope for POC
- Advanced inventory management
- Shipping integrations
- Email notifications
- Marketing features
- Advanced reporting
- Performance optimization

---

## Component Interaction Details

### Frontend ↔ Backend Communication

```
┌─────────────────────────────────────────────────────────────────────┐
│                     API REQUEST/RESPONSE FLOW                        │
└─────────────────────────────────────────────────────────────────────┘

1. USER AUTHENTICATION
   Frontend                    Backend                    Database
   ────────                    ───────                    ────────
   Login Form ──────POST──────▶ /api/auth/login
                               │
                               ├─ Validate Credentials ──▶ Query users table
                               │                            Return user record
                               ├─ Generate JWT Token
                               │
   Store JWT    ◀──JSON────────┤ Return Token + User Data
   in LocalStorage             │

   Subsequent Requests:
   Request      ──────GET──────▶ /api/products
   + JWT Header                │
                               ├─ Verify JWT
                               ├─ Process Request ────────▶ Query products table
                               │                            Return results
   Display Data ◀──JSON────────┤ Return Response


2. PRODUCT BROWSING
   Frontend                    Backend                    Database
   ────────                    ───────                    ────────
   Product List ──────GET──────▶ /api/products?page=1&limit=20
                               │
                               ├─ Parse Query Params
                               ├─ Build SQL Query ────────▶ SELECT with pagination
                               │                            JOIN categories
                               │                            WHERE active = true
   Render      ◀──JSON─────────┤ Return {products[], total, page}
   Products                    │


3. SHOPPING CART
   Frontend                    Backend                    Database
   ────────                    ───────                    ────────
   Add to Cart ──────POST──────▶ /api/cart
   {product_id, qty}           │
                               ├─ Verify JWT
                               ├─ Check Product Stock ────▶ Query inventory
                               ├─ Create/Update Cart ─────▶ INSERT/UPDATE cart_items
                               │
   Update UI   ◀──JSON─────────┤ Return updated cart


4. CHECKOUT & PAYMENT
   Frontend                    Backend                    Payment Gateway
   ────────                    ───────                    ───────────────
   Submit Order ──────POST──────▶ /api/orders
   {cart, shipping}            │
                               ├─ Create Order Record ────▶ INSERT orders
                               ├─ Create Payment Intent ───▶ Stripe API
                               │                            Return client_secret
   Display     ◀──JSON─────────┤ Return {order_id, client_secret}
   Payment UI                  │
                               │
   Confirm     ──────POST──────▶ /api/orders/:id/confirm
   Payment                     │
                               ├─ Verify Payment ─────────▶ Stripe API (verify)
                               ├─ Update Order Status ────▶ UPDATE orders
                               ├─ Reduce Inventory ───────▶ UPDATE products
                               │
   Success     ◀──JSON─────────┤ Return order confirmation
```

### Backend Service Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                      BACKEND SERVICES LAYER                       │
└──────────────────────────────────────────────────────────────────┘

API Layer (Routes)
    │
    ├─ /api/auth/*          ──▶ AuthService
    │                              ├─ UserRepository ──▶ Database
    │                              ├─ JWTService
    │                              └─ PasswordHashService
    │
    ├─ /api/products/*      ──▶ ProductService
    │                              ├─ ProductRepository ──▶ Database
    │                              ├─ CategoryRepository ──▶ Database
    │                              ├─ ImageService ──▶ S3
    │                              └─ CacheService ──▶ Redis (optional)
    │
    ├─ /api/cart/*          ──▶ CartService
    │                              ├─ CartRepository ──▶ Database
    │                              └─ ProductService
    │
    ├─ /api/orders/*        ──▶ OrderService
    │                              ├─ OrderRepository ──▶ Database
    │                              ├─ PaymentService ──▶ Stripe/PayPal
    │                              ├─ InventoryService ──▶ Database
    │                              └─ NotificationService (future)
    │
    └─ /api/admin/*         ──▶ AdminService
                                   ├─ All above services
                                   └─ AdminMiddleware (Auth check)
```

### AWS Infrastructure Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                         AWS VPC                                     │
│                                                                     │
│   ┌──────────────────────────────────────────────────────────┐    │
│   │  Public Subnet (Availability Zone A)                     │    │
│   │                                                           │    │
│   │  ┌────────────────────┐      ┌────────────────────┐     │    │
│   │  │  Application       │      │   Application      │     │    │
│   │  │  Load Balancer     │─────▶│   Server(s)        │     │    │
│   │  │  (ALB)             │      │   ECS/EC2/Fargate  │     │    │
│   │  └────────────────────┘      └─────────┬──────────┘     │    │
│   │           │                             │                │    │
│   └───────────┼─────────────────────────────┼────────────────┘    │
│               │                             │                     │
│   ┌───────────┼─────────────────────────────┼────────────────┐    │
│   │  Private Subnet (Availability Zone A)   │                │    │
│   │                                          │                │    │
│   │                      ┌───────────────────▼──────────┐     │    │
│   │                      │  RDS Primary Instance        │     │    │
│   │                      │  (PostgreSQL/MySQL)          │     │    │
│   │                      └──────────────────────────────┘     │    │
│   └──────────────────────────────────────────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

External Services (Outside VPC)
    ├─ Amazon S3 (Static Assets, Product Images)
    ├─ CloudFront (CDN - Optional)
    ├─ ElastiCache Redis (Session/Cache - Optional)
    └─ Route 53 (DNS)

Security Groups:
    ├─ ALB-SG: Inbound 443 (HTTPS) from 0.0.0.0/0
    ├─ App-SG: Inbound 8080 from ALB-SG only
    └─ RDS-SG: Inbound 5432/3306 from App-SG only
```

---

## Database Schema Design

### Entity Relationship Diagram

```
┌─────────────────────┐         ┌─────────────────────┐
│     users           │         │   categories        │
├─────────────────────┤         ├─────────────────────┤
│ id (PK)             │         │ id (PK)             │
│ email (UNIQUE)      │         │ name                │
│ password_hash       │         │ slug (UNIQUE)       │
│ first_name          │         │ description         │
│ last_name           │         │ parent_id (FK)      │
│ role (ENUM)         │         │ created_at          │
│ created_at          │         │ updated_at          │
│ updated_at          │         └─────────────────────┘
└──────┬──────────────┘                    │
       │                                   │
       │ 1:N                               │ 1:N
       │                                   │
       ▼                                   ▼
┌─────────────────────┐         ┌─────────────────────┐
│     orders          │         │     products        │
├─────────────────────┤         ├─────────────────────┤
│ id (PK)             │    ┌────│ id (PK)             │
│ user_id (FK)        │    │    │ category_id (FK)    │
│ order_number        │    │    │ name                │
│ status (ENUM)       │    │    │ slug (UNIQUE)       │
│ subtotal            │    │    │ description         │
│ tax                 │    │    │ price               │
│ shipping_cost       │    │    │ compare_price       │
│ total               │    │    │ sku                 │
│ payment_status      │    │    │ stock_quantity      │
│ payment_method      │    │    │ image_url           │
│ shipping_address    │    │    │ is_active           │
│ billing_address     │    │    │ created_at          │
│ created_at          │    │    │ updated_at          │
│ updated_at          │    │    └─────────────────────┘
└──────┬──────────────┘    │              │
       │ 1:N               │              │ N:M
       │                   │              │
       ▼                   │              ▼
┌─────────────────────┐    │    ┌─────────────────────┐
│   order_items       │    │    │   cart_items        │
├─────────────────────┤    │    ├─────────────────────┤
│ id (PK)             │    │    │ id (PK)             │
│ order_id (FK)       │    │    │ user_id (FK)        │
│ product_id (FK)     │────┘    │ product_id (FK)     │
│ product_name        │         │ quantity            │
│ quantity            │         │ created_at          │
│ unit_price          │         │ updated_at          │
│ subtotal            │         └─────────────────────┘
│ created_at          │
└─────────────────────┘

┌─────────────────────┐
│   product_images    │
├─────────────────────┤
│ id (PK)             │
│ product_id (FK)     │
│ image_url           │
│ alt_text            │
│ display_order       │
│ created_at          │
└─────────────────────┘

┌─────────────────────┐
│     payments        │
├─────────────────────┤
│ id (PK)             │
│ order_id (FK)       │
│ payment_intent_id   │
│ amount              │
│ currency            │
│ status              │
│ payment_method      │
│ provider            │
│ created_at          │
│ updated_at          │
└─────────────────────┘
```

### Table Definitions

#### users
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) NOT NULL DEFAULT 'customer', -- 'customer', 'admin'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);
```

#### categories
```sql
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id BIGINT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_parent (parent_id)
);
```

#### products
```sql
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    compare_price DECIMAL(10, 2),
    sku VARCHAR(100) UNIQUE,
    stock_quantity INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_category (category_id),
    INDEX idx_sku (sku),
    INDEX idx_active (is_active)
);
```

#### cart_items
```sql
CREATE TABLE cart_items (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id)
);
```

#### orders
```sql
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending', -- 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending', -- 'pending', 'completed', 'failed', 'refunded'
    payment_method VARCHAR(50),
    shipping_address JSON,
    billing_address JSON,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_user (user_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
);
```

#### order_items
```sql
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL, -- Snapshot at time of order
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id)
);
```

#### payments
```sql
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_intent_id VARCHAR(255) UNIQUE, -- Stripe/PayPal transaction ID
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'NZD',
    status VARCHAR(20) NOT NULL, -- 'pending', 'succeeded', 'failed', 'cancelled'
    payment_method VARCHAR(50),
    provider VARCHAR(20) NOT NULL, -- 'stripe', 'paypal'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_intent (payment_intent_id)
);
```

#### product_images
```sql
CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product (product_id)
);
```

---

## Testing & Validation

### Functional Testing
- [ ] User registration and login
- [ ] Product browsing and search
- [ ] Add to cart and update cart
- [ ] Checkout process
- [ ] Payment processing (test mode)
- [ ] Admin product management

### Technical Validation
- [ ] AWS infrastructure stability
- [ ] Database connection and performance
- [ ] API response times
- [ ] Security measures (HTTPS, authentication)
- [ ] Error handling

### Performance Metrics
- Page load time: TBD
- API response time: TBD
- Database query time: TBD
- Concurrent users supported: TBD

---

## API Endpoints Specification

### Authentication Endpoints
```
POST   /api/auth/register          - Create new user account
POST   /api/auth/login             - Authenticate user and return JWT
POST   /api/auth/logout            - Invalidate user session
GET    /api/auth/me                - Get current user profile
PUT    /api/auth/me                - Update user profile
```

### Product Endpoints
```
GET    /api/products               - List all products (paginated, filterable)
GET    /api/products/:id           - Get single product details
GET    /api/products/slug/:slug    - Get product by slug
GET    /api/categories             - List all categories
GET    /api/categories/:id         - Get category with products
```

### Cart Endpoints
```
GET    /api/cart                   - Get current user's cart
POST   /api/cart                   - Add item to cart
PUT    /api/cart/:id               - Update cart item quantity
DELETE /api/cart/:id               - Remove item from cart
DELETE /api/cart                   - Clear entire cart
```

### Order Endpoints
```
POST   /api/orders                 - Create new order
GET    /api/orders                 - List user's orders
GET    /api/orders/:id             - Get order details
POST   /api/orders/:id/confirm     - Confirm payment and finalize order
```

### Admin Endpoints
```
GET    /api/admin/products         - List all products (admin view)
POST   /api/admin/products         - Create new product
PUT    /api/admin/products/:id     - Update product
DELETE /api/admin/products/:id     - Delete product
GET    /api/admin/orders           - List all orders
PUT    /api/admin/orders/:id       - Update order status
GET    /api/admin/customers        - List all customers
```

---

## Security Considerations

### Authentication & Authorization
- **JWT-based Authentication**: Secure token-based auth with expiration
- **Password Hashing**: bcrypt/argon2 for password storage
- **Role-Based Access Control (RBAC)**: Customer vs Admin roles
- **Protected Routes**: Middleware to verify JWT on protected endpoints

### Data Security
- **HTTPS Only**: All traffic encrypted with SSL/TLS
- **Input Validation**: Sanitize all user inputs to prevent injection attacks
- **SQL Injection Prevention**: Use parameterized queries/ORM
- **XSS Protection**: Escape output, Content Security Policy headers
- **CSRF Protection**: CSRF tokens for state-changing operations

### Payment Security
- **PCI Compliance**: Never store credit card details
- **Stripe/PayPal Integration**: Use secure payment gateway APIs
- **Webhook Verification**: Verify payment gateway webhooks

### AWS Security
- **Security Groups**: Restrict access to only necessary ports
- **IAM Roles**: Least privilege principle for service access
- **RDS Encryption**: Encrypt data at rest
- **S3 Bucket Policies**: Secure file storage with proper access controls
- **Environment Variables**: Store sensitive credentials in AWS Secrets Manager

---

## Performance Optimization Strategy

### Database Optimization
- **Indexing**: Strategic indexes on frequently queried columns
- **Query Optimization**: Use EXPLAIN to analyze and optimize slow queries
- **Connection Pooling**: Efficient database connection management
- **Read Replicas**: (Future) Separate read/write operations

### Caching Strategy
- **Redis Cache**: (Optional) Cache frequently accessed data
  - Product catalog
  - Category lists
  - User sessions
- **CDN**: CloudFront for static assets and images
- **Browser Caching**: Proper cache headers for static content

### Application Performance
- **Code Splitting**: Load only necessary frontend code
- **Lazy Loading**: Load images and components on demand
- **API Response Pagination**: Limit data returned per request
- **Compression**: Gzip/Brotli compression for API responses

---

## Key Technical Decisions

### Decision 1: Database Selection
**Decision:** PostgreSQL on AWS RDS
**Rationale:**
- Strong ACID compliance for financial transactions
- Excellent support for JSON data types (for addresses, metadata)
- Mature ecosystem and AWS integration
- Better performance for complex queries vs MySQL

**Alternatives Considered:** MySQL, MongoDB

### Decision 2: Authentication Strategy
**Decision:** JWT-based authentication
**Rationale:**
- Stateless authentication suitable for API-driven architecture
- Scalable across multiple servers
- Easy to implement and secure
- Industry standard for SPAs

**Alternatives Considered:** Session-based auth, OAuth2

### Decision 3: File Storage
**Decision:** AWS S3 for product images and assets
**Rationale:**
- Highly scalable and durable
- Cost-effective for large file storage
- Easy CDN integration with CloudFront
- Built-in versioning and backup capabilities

**Alternatives Considered:** Local file system, third-party CDN

### Decision 4: Payment Gateway
**Decision:** Stripe (Primary), PayPal (Secondary)
**Rationale:**
- Stripe: Modern API, excellent developer experience, comprehensive features
- PayPal: Popular in NZ, trusted by consumers
- Both support NZD currency
- Easy to implement test mode for POC

**Alternatives Considered:** Windcave (local NZ gateway)

---

## POC Success Criteria

### Technical Validation
- [ ] All core user flows functional (browse → cart → checkout → payment)
- [ ] Database schema supports all POC features
- [ ] AWS infrastructure deployed and stable
- [ ] API endpoints respond within acceptable time (< 500ms avg)
- [ ] Payment integration working in test mode
- [ ] Admin panel functional for basic operations
- [ ] Security measures implemented (HTTPS, JWT, input validation)

### Deliverables
- [ ] Working POC application (demo environment)
- [ ] Source code repository with clean, documented code
- [ ] Database schema implemented and documented (this file)
- [ ] API endpoint documentation (this file)
- [ ] AWS infrastructure diagram and configuration notes
- [ ] Technical architecture documentation (this file)
- [ ] POC demo presentation/walkthrough

---

## Next Steps & Recommendations

### For Phase 1 Development
1. **Finalize Technology Stack**: Choose specific frameworks based on POC learnings
2. **Enhanced Database Schema**: Add tables for shipping, reviews, wishlists
3. **Implement Comprehensive Testing**: Unit, integration, and E2E tests
4. **Setup CI/CD Pipeline**: Automated deployment to staging/production
5. **Performance Baseline**: Establish performance metrics from POC
6. **Security Audit**: Full security review before production

### Known Limitations in POC
- No email notification system
- No shipping integration
- No advanced inventory management
- Limited error handling
- Basic admin interface
- No analytics/reporting features

### Recommended Phase 1 Enhancements
- Implement comprehensive logging and monitoring
- Add email notifications for orders
- Integrate shipping providers
- Enhanced admin dashboard with analytics
- Implement product reviews and ratings
- Add wishlist functionality
- Multi-image support for products
- Advanced search with filters

---

**End of POC Documentation**
