-- =============================================================================
-- UQ-DB-101 / N2 · uq_enterprise
-- 状态: 草稿交审序；**禁止执行写库**直至林开窗 + 备份
-- 库: ry-smartpark · utf8mb4 / utf8mb4_unicode_ci
-- 对照: UQ-DB-101 · BE-DIGEST-N2-RND101 · 禁直拷旧 RND-DBS-101
-- 分支: agent/n2-uq-enterprise-sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1) DDL
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `uq_enterprise` (
  `id`                bigint(20)      NOT NULL                   COMMENT '主键',
  `tenant_id`         varchar(20)     NOT NULL DEFAULT '000000'  COMMENT '租户编号',
  `enterprise_name`   varchar(128)    NOT NULL                   COMMENT '企业名称',
  `credit_code`       varchar(32)     NOT NULL                   COMMENT '统一社会信用代码',
  `settle_location`   varchar(256)             DEFAULT NULL      COMMENT '入驻位置（文本）',
  `lease_area`        decimal(12,2)            DEFAULT NULL      COMMENT '租赁面积（㎡）',
  `settle_status`     varchar(32)     NOT NULL DEFAULT 'PENDING' COMMENT '入驻状态 IN_PARK/PENDING/LEFT',
  `contact_name`      varchar(64)              DEFAULT NULL      COMMENT '主联系人姓名',
  `contact_phone`     varchar(32)              DEFAULT NULL      COMMENT '主联系人手机',
  `remark`            varchar(500)             DEFAULT NULL      COMMENT '备注',
  `del_flag`          char(1)                  DEFAULT '0'       COMMENT '删除标志（0存在 1删除）',
  `create_dept`       bigint(20)               DEFAULT NULL      COMMENT '创建部门',
  `create_by`         bigint(20)               DEFAULT NULL      COMMENT '创建者',
  `create_time`       datetime                 DEFAULT NULL      COMMENT '创建时间',
  `update_by`         bigint(20)               DEFAULT NULL      COMMENT '更新者',
  `update_time`       datetime                 DEFAULT NULL      COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uq_enterprise_tenant_credit` (`tenant_id`, `credit_code`),
  KEY `idx_uq_enterprise_name` (`tenant_id`, `enterprise_name`),
  KEY `idx_uq_enterprise_status` (`tenant_id`, `settle_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='园擎-企业档案（N2最小）';

-- -----------------------------------------------------------------------------
-- 2) 回滚叙述（执行前确认无业务依赖；仍须备份）
-- -----------------------------------------------------------------------------
-- DROP TABLE IF EXISTS `uq_enterprise`;

-- -----------------------------------------------------------------------------
-- 3) 字典种子（可选 · 仅数据行；表结构 sys_dict_* 原样）
--    类型: uq_enterprise_settle_status
--    注意: dict_id / dict_code 须按环境现网最大值避冲突；以下为占位，审序后定号
-- -----------------------------------------------------------------------------
-- INSERT INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
-- VALUES (/*TODO*/, '000000', '企业入驻状态', 'uq_enterprise_settle_status', NULL, NULL, NOW(), 'UQ-DB-101 N2');
-- INSERT INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- (/*TODO*/, '000000', 1, '在园',   'IN_PARK', 'uq_enterprise_settle_status', '', 'success', 'N', NULL, NULL, NOW(), ''),
-- (/*TODO*/, '000000', 2, '待入驻', 'PENDING', 'uq_enterprise_settle_status', '', 'warning', 'Y', NULL, NULL, NOW(), ''),
-- (/*TODO*/, '000000', 3, '已退租', 'LEFT',    'uq_enterprise_settle_status', '', 'info',    'N', NULL, NULL, NOW(), '');

-- -----------------------------------------------------------------------------
-- 4) 菜单种子（编码阶段另稿 · perms 对齐 UQ-API-101）
--    site:enterprise:list|query|add|edit[/remove]
-- -----------------------------------------------------------------------------
