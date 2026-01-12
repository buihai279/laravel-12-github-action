# Migration Plan: Laravel 8 → Laravel 12 với PHP 8.4

## Phân tích hiện tại

### Thông tin project hiện tại
- **Laravel Version**: 8.0
- **PHP Version**: ^8.0
- **Database**: MySQL
- **Frontend**: Laravel Mix + Webpack 5
- **Locale**: Vietnamese (vi)

### Dependencies chính
```json
{
  "laravel/framework": "^8.0",
  "laravel/sanctum": "^2.3",
  "laravel/tinker": "^2.0",
  "intervention/image": "^2.5",
  "maatwebsite/excel": "^3.1",
  "laravelium/sitemap": "^8.0",
  "google/apiclient": "^2.0",
  "predis/predis": "^1.1"
}
```

### Cấu trúc ứng dụng
- **Models**: User, Post, Comment, Folder, Tag, Role, Campaign, Banner, Build*
- **Controllers**: Front (public) và CMS (admin)
- **Jobs**: Background processing cho các tác vụ
- **Events/Listeners**: Comment interactions
- **Policies**: Authorization cho các models
- **Resources**: API Resources
- **Middleware**: Custom middleware

## Migration Strategy

### Phase 1: Preparation (Backup & Environment)
1. **Backup toàn bộ dữ liệu**
   - Database dump
   - Storage files
   - Code repository

2. **Setup môi trường development**
   - PHP 8.4
   - Composer 2.x
   - Node.js 18+
   - MySQL 8.0+

### Phase 2: Step-by-Step Laravel Migration

#### Bước 1: Laravel 8 → 9
```bash
# Cập nhật composer.json
"php": "^8.1",
"laravel/framework": "^9.0"

# Key changes:
- Anonymous migrations
- New query builder methods
- Updated test skeleton
```

#### Bước 2: Laravel 9 → 10
```bash
# Cập nhật composer.json
"php": "^8.1",
"laravel/framework": "^10.0"

# Key changes:
- Native type declarations
- Process facade improvements
- New test assertion methods
```

#### Bước 3: Laravel 10 → 11
```bash
# Cập nhật composer.json
"php": "^8.2",
"laravel/framework": "^11.0"

# Key changes:
- Slimmed application skeleton
- New application defaults
- Improved routing
```

#### Bước 4: Laravel 11 → 12
```bash
# Cập nhật composer.json
"php": "^8.3",
"laravel/framework": "^12.0"

# Key changes:
- PHP 8.3+ features
- Updated package dependencies
- Performance improvements
```

### Phase 3: Dependencies Updates

#### Packages cần cập nhật
```json
{
  "intervention/image": "^3.0",
  "maatwebsite/excel": "^4.0", 
  "laravelium/sitemap": "^9.0",
  "predis/predis": "^2.0"
}
```

#### Packages cần thay thế
- `laravel-mix` → `vite`
- `fideloper/proxy` → `symfony/http-client`
- `fruitcake/laravel-cors` → built-in CORS

### Phase 4: Code Updates

#### 1. Model Changes
```php
// Laravel 12 style
class Post extends Model
{
    protected $fillable = [
        'title',
        'content',
        // ...
    ];
    
    // Casts với strict typing
    protected function casts(): array
    {
        return [
            'published_at' => 'datetime',
            'is_active' => 'boolean',
        ];
    }
}
```

#### 2. Controller Updates
```php
// Route model binding improvements
public function show(Post $post): Response
{
    return view('posts.show', compact('post'));
}
```

#### 3. Migration Updates
```php
// Anonymous migrations
return new class extends Migration {
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table): void {
            $table->id();
            // ...
        });
    }
};
```

#### 4. Frontend Migration (Laravel Mix → Vite)
```javascript
// vite.config.js
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
});
```

### Phase 5: Breaking Changes Fix

#### 1. Deprecated Methods
- `Str::uuid()` → `Str::uuid()`
- `Request::segment()` → `$request->segment()`
- Various facade method updates

#### 2. Array/String Helper Updates
```php
// Old
Arr::first($array, $callback);
// New  
Arr::first($array, $callback, $default);
```

#### 3. Validation Updates
```php
// New syntax
$request->validate([
    'email' => ['required', 'email', 'max:255'],
]);
```

### Phase 6: Testing & Verification

#### Test Cases cần verify
1. **Authentication flow**
2. **CRUD operations**
3. **File uploads**
4. **API endpoints**
5. **Background jobs**
6. **Email notifications**

#### Performance Testing
- Response time benchmarks
- Memory usage comparison
- Database query optimization

### Phase 7: Deployment

#### Production Deployment Steps
1. **Staging environment testing**
2. **Database migration on production**
3. **Asset compilation**
4. **Cache clearing**
5. **Monitoring setup**

## Timeline Estimate

| Phase | Duration | Notes |
|-------|----------|-------|
| Preparation | 1-2 days | Backup & setup |
| Laravel Migration | 3-5 days | Step-by-step upgrades |
| Dependencies Update | 2-3 days | Package compatibility |
| Code Updates | 5-7 days | Models, controllers, views |
| Testing | 3-4 days | Comprehensive testing |
| Deployment | 1-2 days | Production rollout |

**Total Estimated Time**: 15-23 days

## Risk Assessment

### High Risk Items
1. **Database schema changes**
2. **Third-party package compatibility**
3. **Custom middleware functionality**
4. **Frontend build process**

### Medium Risk Items
1. **Authentication system**
2. **File upload handling**
3. **Email configuration**
4. **Background job processing**

### Low Risk Items
1. **Basic CRUD operations**
2. **View templates**
3. **Routing configuration**
4. **Configuration files**

## Rollback Plan

1. **Database backup restoration**
2. **Code repository rollback**
3. **Environment configuration revert**
4. **Asset compilation rollback**

## Success Criteria

1. ✅ All existing functionality working
2. ✅ Performance maintained or improved
3. ✅ Security patches up to date
4. ✅ PHP 8.4 features utilized
5. ✅ Laravel 12 features implemented
6. ✅ Zero data loss
7. ✅ Comprehensive test coverage

## Next Steps

1. **Approve migration plan**
2. **Schedule migration window**
3. **Prepare backup strategy**
4. **Setup development environment**
5. **Begin Phase 1 implementation**