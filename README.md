# 综合评分UI组件 Demo

这是一个Flutter项目，展示了评分卡片UI的组件实现。

## 功能特性

- 🎯 **综合评分卡片**: 精美的评分展示UI
- 📊 **五边形雷达图**: 自定义绘制的雷达图组件  
- 🎨 **响应式设计**: 适配不同屏幕尺寸
- 🌈 **Material Design**: 采用Material3设计规范

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── pages/
│   └── demo_page.dart          # Demo展示页面
└── widgets/
    ├── score_rating_card.dart   # 评分卡片组件
    └── pentagon_radar_chart.dart # 五边形雷达图组件
```

## 组件说明

### ScoreRatingCard 评分卡片

主要的评分展示组件，包含：
- 大号分数显示
- 百分比对比文字  
- 五边形雷达图展示

**参数:**
- `score`: 评分（整数）
- `percentage`: 击败百分比
- `radarData`: 雷达图数据（Map<String, double>）

### PentagonRadarChart 五边形雷达图

自定义绘制的雷达图组件，支持：
- 五边形网格背景
- 数据区域填充
- 可自定义颜色
- 标签显示

## 运行项目

1. 确保已安装Flutter环境
2. 克隆或下载项目
3. 在项目目录下运行：

```bash
flutter pub get
flutter run
```

## 测试

运行测试：

```bash
flutter test
```

## 截图预览

应用展示了三个不同评分的卡片示例：
- 高分示例（95分）
- 中等分数示例（76分）  
- 较低分数示例（58分）

每个卡片都有对应的雷达图数据，展示不同维度的评价指标。
