# ExamPortal — Online MCQ Exam & Instant Practice Platform

A full-featured online MCQ examination and instant practice portal built with **Laravel 12**, **Tailwind CSS**, **Alpine.js**, and **MySQL (XAMPP / phpMyAdmin)**.

---

## Key Features

- **Dual Exam Modes**
  - **Instant Answer Mode (Practice):** AJAX-powered immediate answer verification with green/red option highlights, marks awarded, optional post-reveal locking, and detailed explanations.
  - **Standard Timed Mode (Assessment):** Server-enforced countdown timer with automatic submission on expiry, hidden answer keys until completion, and optional negative marking.
- **Interactive Exam Runner**
  - Live completion progress bar and color-coded **Question Palette** (Current, Answered, Marked for Review, Unanswered).
  - Randomized question and option ordering per attempt.
  - Tab-switch integrity counter (`visibilitychange` tracking), question bookmarking, and question issue reporting.
- **Post-Exam Analytics & Certificates**
  - Detailed question-by-question answer review with explanations.
  - Exam **Leaderboards** ranked by score and completion time.
  - Downloadable **PDF Scorecards & Certificates** with unique verification IDs (`barryvdh/laravel-dompdf`).
- **Admin & Examiner Panel**
  - Role-based access control (`admin`, `examiner`, `student`).
  - Category & Subject CRUD, Question Bank CRUD (single choice, multiple choice, true/false, image support), and **Bulk CSV Import** with a downloadable sample template.
  - Exam Builder with question assignment, results viewer, and CSV export.
  - Student-reported question moderation and user role management.

---

## Tech Stack

- **Backend:** PHP 8.2+, Laravel 12, Laravel Breeze
- **Database:** MySQL / MariaDB (`exam` database via XAMPP / phpMyAdmin)
- **Frontend:** Blade, Tailwind CSS, Alpine.js, Vite
- **PDF Generation:** `barryvdh/laravel-dompdf`

---

## Seeded Subjects & Exams

1. **Laravel & PHP** — *Laravel & PHP Mastery (Instant Answer)*
2. **Database & MySQL** — *MySQL & Web Security (Timed Assessment)*
3. **General Knowledge** — *General Knowledge & World Affairs (Instant Answer)*
4. **History** — *World & Modern History (Timed Assessment)*
5. **Basic Mathematics** — *Basic Mathematics & Aptitude (Instant Answer)*
6. **English Grammar** — *English Grammar & Usage Mastery (Instant Answer)*
7. **Computer Science** — *Computer Science Fundamentals (Timed Assessment)*
8. **Digital Marketing** — *Digital Marketing & SEO Essentials (Instant Answer)*

---

## Quick Start with Docker (Recommended)

Run the entire application stack (Laravel 12, Nginx, MySQL 8.0, and phpMyAdmin) in isolated containers without needing PHP, Composer, Node.js, or MySQL installed on your host machine.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (macOS / Windows / Linux) with Docker Compose v2.

### 1. Configure Environment

Copy the Docker-tailored environment configuration:
```bash
cp .env.docker.example .env
```

### 2. Build and Start the Containers

```bash
docker compose up -d --build
```
> The container entrypoint will automatically install Composer packages, generate your `APP_KEY`, wait for the MySQL service health check, and set up the storage symlink.

### 3. Initialize & Seed Database

Run migrations and seed the demo subjects, questions, and sample user accounts:
```bash
docker compose exec app php artisan migrate --seed
```

### 4. Access the Application

- **Web Application:** [http://localhost:8000](http://localhost:8000)
- **phpMyAdmin (Database GUI):** [http://localhost:8080](http://localhost:8080)
  - **Server:** `db`
  - **Username:** `exam_user` (or `root`)
  - **Password:** `secret` (or `root_secret`)
- **MySQL Direct Access:** `localhost:3306`

### 5. Useful Docker Commands

```bash
# View live application & container logs
docker compose logs -f app

# Run Artisan commands inside the app container
docker compose exec app php artisan route:list
docker compose exec app php artisan tinker

# Run tests in container
docker compose exec app php artisan test

# Re-run frontend asset build if modified
docker compose exec app npm run build

# Stop containers
docker compose down

# Stop containers and remove database volume (fresh start)
docker compose down -v
```

---

## Local Setup (XAMPP + MySQL)

1. **Clone the repository**
   ```bash
   git clone https://github.com/webotapp-academy/exam-portal.git
   cd exam-portal
   ```

2. **Install dependencies**
   ```bash
   composer install
   npm install && npm run build
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```
   Update `.env` with your XAMPP MySQL `exam` database credentials:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=exam
   DB_USERNAME=root
   DB_PASSWORD=
   ```

4. **Migrate & seed the database**
   ```bash
   php artisan storage:link
   php artisan migrate --seed
   ```

5. **Run tests**
   ```bash
   php artisan test
   ```

---

## Demo Accounts

All seeded accounts use the password: `password`

| Role | Email |
| :--- | :--- |
| **Admin** | `admin@examportal.test` |
| **Examiner** | `examiner@examportal.test` |
| **Student** | `student@examportal.test` |
