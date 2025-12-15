# ComponentTool API 文档

本文档详细介绍了ComponentTool插件的核心类和方法，帮助开发者理解和使用组件系统。

## 核心类

### Component 抽象类

组件基类，所有自定义组件都必须继承自此类。

**文件路径**: `addons/component_tool/core/component.gd`

**属性**:

| 属性名 | 类型 | 默认值 | 描述 |
| ------ | ---- | ------ | ---- |
| `comp_enable` | bool | true | 组件是否启用 |
| `component_host` | Node | null | 组件的宿主节点 |
| `component_name` | String | "Component" | 组件的名称 |

**方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `_enable()` | 无 | 无 | 抽象方法，组件启用时调用 |
| `_disable()` | 无 | 无 | 抽象方法，组件禁用时调用 |
| `set_comp_enable(enable: bool)` | `enable`: 是否启用 | 无 | 设置组件的启用状态 |

**示例**:

```gdscript
class_name CharacterBody2DMovementComponent
extends Component

func _enable():
    component_name = "CharacterBody2DMovementComponent"
    # 初始化组件
    
func _disable():
    # 清理组件
    pass
```

### ComponentToolManager 类

组件工具管理器，用于管理组件的启用/禁用状态。

**文件路径**: `addons/component_tool/core/component_tool_manager.gd`

**信号**:

| 信号名 | 参数 | 描述 |
| ------ | ---- | ---- |
| `comp_enable_changed` | `host: Node`, `comp_name: String`, `enable: bool` | 组件启用状态变化时触发 |

**方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `set_current_node_comp_enable(comp_name: String, enable: bool)` | `comp_name`: 组件名称<br>`enable`: 是否启用 | 无 | 设置当前选中节点的组件启用状态 |
| `set_node_comp_enable(node: Node, comp_name: String, enable: bool)` | `node`: 节点<br>`comp_name`: 组件名称<br>`enable`: 是否启用 | 无 | 设置指定节点的组件启用状态 |

### ComponentUtil 工具类

组件工具类，提供了各种组件相关的工具方法。

**文件路径**: `addons/component_tool/core/component_util.gd`

**静态方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `get_object_all_types(object: Object)` | `object`: 对象 | PoolStringArray | 获取对象的所有类型 |
| `get_components(node: Node)` | `node`: 节点 | Array | 获取节点的所有组件 |
| `find_component(node: Node, comp_name: String)` | `node`: 节点<br>`comp_name`: 组件名称 | Component | 查找节点的指定组件 |
| `set_component_enable(node: Node, comp_name: String, enable: bool)` | `node`: 节点<br>`comp_name`: 组件名称<br>`enable`: 是否启用 | bool | 设置组件的启用状态 |
| `get_default_script_dir()` | 无 | String | 获取默认脚本目录 |
| `get_component_template_path()` | 无 | String | 获取组件模板路径 |
| `generate_component_file_path(host_type: String, component_name: String, location: String)` | `host_type`: 宿主类型<br>`component_name`: 组件名称<br>`location`: 位置 | String | 生成组件文件路径 |
| `create_file(file_path: String, content: String)` | `file_path`: 文件路径<br>`content`: 文件内容 | bool | 创建文件 |
| `add_script_child_node(node: Node, script_path: String)` | `node`: 节点<br>`script_path`: 脚本路径 | Node | 添加脚本子节点 |
| `get_current_selected_node()` | 无 | Node | 获取当前选中的节点 |
| `get_host_types()` | 无 | Array | 获取宿主类型列表 |
| `get_node_script_path(node: Node)` | `node`: 节点 | String | 获取节点的脚本路径 |

## 界面控制器

### CompCenter 类

组件工具主界面控制器，负责管理界面元素和用户交互。

**文件路径**: `addons/component_tool/ui/comp_center.gd`

**方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `_ready()` | 无 | 无 | 节点准备就绪时调用，初始化界面元素 |
| `_on_selection_changed()` | 无 | 无 | 选择变化时调用，更新组件列表 |
| `_update_comp_list()` | 无 | 无 | 更新组件列表 |
| `_on_button_create_pressed()` | 无 | 无 | 创建组件按钮按下时调用 |
| `_on_create_component_window_close()` | 无 | 无 | 创建组件窗口关闭时调用 |

### CreateComponent 类

创建组件界面控制器，负责组件创建界面的交互逻辑。

**文件路径**: `addons/component_tool/ui/create_component.gd`

**信号**:

| 信号名 | 参数 | 描述 |
| ------ | ---- | ---- |
| `create_finished` | 无 | 组件创建完成时触发 |

**方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `_ready()` | 无 | 无 | 节点准备就绪时调用，初始化界面元素 |
| `set_host_types(host_types: Array)` | `host_types`: 宿主类型列表 | 无 | 设置宿主类型列表 |
| `update_ui()` | 无 | 无 | 更新界面元素 |
| `_on_button_create_pressed()` | 无 | 无 | 创建按钮按下时调用，生成组件文件 |

### CompItem 类

组件项界面控制器，负责单个组件项的显示和交互。

**文件路径**: `addons/component_tool/ui/comp_item.gd`

**方法**:

| 方法名 | 参数 | 返回值 | 描述 |
| ------ | ---- | ------ | ---- |
| `_ready()` | 无 | 无 | 节点准备就绪时调用，连接信号 |
| `_on_comp_enable_toggled(toggled_on: bool)` | `toggled_on`: 是否启用 | 无 | 组件启用复选框状态变化时调用 |
| `_on_comp_enable_changed(host: Node, comp_name: String, enable: bool)` | `host`: 宿主节点<br>`comp_name`: 组件名称<br>`enable`: 是否启用 | 无 | 组件启用状态变化时调用 |

## 组件模板

组件模板文件用于生成新组件的基础代码。

**文件路径**: `addons/component_tool/template/component_template.txt`

**模板变量**:

| 变量名 | 描述 |
| ------ | ---- |
| `<HostType>` | 宿主节点的类型名称 |
| `<ComponentName>` | 组件功能名称 |
| `<HostName>` | 宿主节点的实例变量名（小写开头驼峰式） |

**模板内容**:

```gdscript
class_name <HostType><ComponentName>Component
extends Component

var <HostName>: <HostType>

func _enable():
    <HostName> = component_host
    component_name = "<HostType><ComponentName>Component"
    pass

func _disable():
    pass

func _physics_process(delta: float) -> void:
    if not comp_enable:
        return
    pass
```

## 使用示例

### 创建一个简单的移动组件

```gdscript
# 1. 在编辑器中选择一个CharacterBody2D节点
# 2. 点击组件工具面板中的"创建组件"按钮
# 3. 选择"CharacterBody2D"作为宿主类型
# 4. 输入"Movement"作为组件名称
# 5. 点击"创建"按钮生成组件文件

# 生成的组件文件内容
class_name CharacterBody2DMovementComponent
extends Component

var characterBody2D: CharacterBody2D

func _enable():
    characterBody2D = component_host
    component_name = "CharacterBody2DMovementComponent"
    pass

func _disable():
    pass

func _physics_process(delta: float) -> void:
    if not comp_enable:
        return
    
    # 实现移动逻辑
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
    characterBody2D.velocity = direction
    characterBody2D.move_and_slide()
```

### 管理组件

```gdscript
# 获取节点的所有组件
var components = ComponentUtil.get_components(character_body_2d)

# 查找指定组件
var movement_component = ComponentUtil.find_component(character_body_2d, "CharacterBody2DMovementComponent")

# 启用/禁用组件
ComponentUtil.set_component_enable(character_body_2d, "CharacterBody2DMovementComponent", false)
```

