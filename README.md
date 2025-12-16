# ComponentTool 插件 v1.0.0

ComponentTool是一款Godot引擎的插件，用于将代码组件化，将它们拆分为更加聚合的逻辑块。通过组件化的方式，可以提高代码的复用性、可维护性和可扩展性。

## 功能特性

- ✅ 创建和管理组件
- ✅ 组件启用/禁用控制
- ✅ 基于模板生成组件代码
- ✅ 支持自定义组件类型
- ✅ 可视化组件管理界面

## 安装方法

1. 将`component_tool`文件夹复制到Godot项目的`addons`目录下
2. 在Godot编辑器中，打开"项目设置" > "插件"
3. 找到"ComponentTool"并启用它

## 使用方法

### 创建组件

1. 在编辑器中选择一个节点
2. 点击组件工具面板中的"创建组件"按钮
3. 选择宿主类型和组件位置
4. 输入组件名称和代码
5. 点击"创建"按钮生成组件文件

### 管理组件

1. 在编辑器中选择一个节点
2. 组件工具面板会显示该节点的所有组件
3. 使用复选框启用或禁用组件

### 使用组件

创建的组件会自动继承自`Component`基类，包含以下功能：

- `comp_enable`: 控制组件是否启用
- `component_host`: 宿主节点引用
- `component_name`: 组件名称

组件类需要实现以下方法：

- `_enable()`: 组件启用时调用
- `_disable()`: 组件禁用时调用

## 示例

以下是一个简单的移动组件示例：

```gdscript
class_name CharacterBody2DMovementComponent
extends Component

var character_body_2d: CharacterBody2D

func _enable():
    character_body_2d = component_host
    component_name = "CharacterBody2DMovementComponent"
    
func _disable():
    pass

func _physics_process(delta: float) -> void:
    if not comp_enable:
        return
    
    var direction = Vector2.ZERO
    if Input.is_action_pressed("ui_right"):
        direction.x += 1
    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
    if Input.is_action_pressed("ui_down"):
        direction.y += 1
    if Input.is_action_pressed("ui_up"):
        direction.y -= 1
    
    direction = direction.normalized() * 200.0
    character_body_2d.velocity = direction
    character_body_2d.move_and_slide()
```

## 项目结构

```
addons/component_tool/
├── component_tool.gd      # 插件主入口
├── core/                 # 核心代码
│   ├── component.gd      # 组件基类
│   ├── component_tool_manager.gd  # 组件管理器
│   └── component_util.gd # 工具函数
├── template/             # 模板文件
│   └── component_template.txt  # 组件模板
└── ui/                   # UI界面
    ├── comp_center.gd    # 主界面控制器
    ├── comp_item.gd      # 组件项控制器
    └── create_component.gd  # 创建组件界面控制器
```

## 注意事项

1. 组件可以放在插件目录中或者项目自定义目录下
2. 确保组件类名遵循`<HostType><ComponentName>Component`的命名规范
3. 在组件的`_enable()`方法中获取宿主节点引用
4. 在组件的更新方法中检查`comp_enable`状态



## 开发者

- 作者: Smalldy
- 邮箱: [743682730@qq.com]

## 许可证

MIT License
