import qs

Icon {
  id: root
  required property int capacity
  required property bool charging
  iconWidth: 24
  iconHeight: 24

  FluentShapePath {
    path: 'M 17 6 Q 18.2426 6 19.1213 6.87868 Q 20 7.75736 20 9 L 20 10 L 21 10 Q 21.4142 10 21.7071 10.2929 Q 22 10.5858 22 11 L 22 13 Q 22 13.4142 21.7071 13.7071 Q 21.4142 14 21 14 L 20 14 L 20 15 Q 20 16.2426 19.1213 17.1213 Q 18.2426 18 17 18 L 5 18 Q 3.75736 18 2.87868 17.1213 Q 2 16.2426 2 15 L 2 9 Q 2 7.75736 2.87868 6.87868 Q 3.75736 6 5 6 L 17 6 M 16.998 7.5 L 5 7.5 Q 4.42053 7.50003 3.99158 7.88962 Q 3.56263 8.27921 3.507 8.856 L 3.5 9 L 3.5 15 Q 3.49999 15.5792 3.88925 16.0081 Q 4.27851 16.437 4.855 16.493 L 5 16.5 L 16.998 16.5 Q 17.5772 16.5 18.0061 16.1108 Q 18.435 15.7215 18.491 15.145 L 18.498 15 L 18.498 9 Q 18.498 8.42079 18.1088 7.99189 Q 17.7195 7.56299 17.143 7.507 L 16.998 7.5'
  }

  FluentShapePath {
    readonly property real capacityRight: 6 + root.capacity / 10
    color: root.charging ? Theme.green : Theme.text
    path: `M 6 9 L ${capacityRight} 9 Q ${capacityRight + 0.3802} 9.00005 ${capacityRight + 0.6644} 9.25272 Q ${capacityRight + 0.9485} 9.50538 ${capacityRight + 0.993} 9.883 L ${capacityRight + 1} 10 L ${capacityRight + 1} 14 Q ${capacityRight + 1} 14.3802 ${capacityRight + 0.7473} 14.6644 Q ${capacityRight + 0.4946} 14.9485 ${capacityRight + 0.117} 14.993 L ${capacityRight} 15 L 6 15 Q 5.61948 15.0003 5.335 14.7476 Q 5.05052 14.4949 5.006 14.117 L 5 14 L 5 10 Q 5.00005 9.61977 5.25272 9.33563 Q 5.50538 9.05149 5.883 9.007 L 6 9`
  }
}
