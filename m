Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C2208981;
	Fri, 11 Oct 2024 06:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728627603; cv=fail; b=K9WP18fd9dzctWzyBod5YGXl4WFJHQQWzAiij2v+98WSG6OnnloGrt1AkSQKDKST+CdW4rGCd9MYmblyjbVbElnuCEN1L/4jsKGMbqiDVqvGH6NZMSyjQMa9N/yxYnGi47A6v+9+ktjJnrGLrj2h6KuR1tZfSKbkENAEP6/xk7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728627603; c=relaxed/simple;
	bh=F9S9uk8JNoT74TGqe83YZowyuefHQ6MKWfYicBWrCH4=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uI1B9NU+dEXqXh00Q1x8ES0L85gdh8O9qaYG6hOsn+M2XC0OuP6dgREeGn1D4mQq2f/72P6dEzojEVJ1dCERLiHU5GS5TPnS5z+CZpNo9YhRMXpMhS/Z+eS9uvr5dbwPBuE+t5akFpaFHTWiL33gg8KWVtK+HxG+6a16O0btVk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lhV8okoI; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lhV8okoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728627601; x=1760163601;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=F9S9uk8JNoT74TGqe83YZowyuefHQ6MKWfYicBWrCH4=;
  b=lhV8okoIZH54kR4fxYskjsmPHviUgI7R/NTY4EJuVsUA8l04sp4G9dqr
   Gevd9vNQ+K72LIdefIlbNKVvAmy5AEUgY7XyBIe7b66GhX0sF+NCZxkhb
   3MgfUc2Ncx/EN27hKWqRWbBlJQNwQXa1Aui3aV/UkDGEdEr+XxJGnMqd1
   dYhehBo9d1BBhjhPCwBrpZ+DsKDks7iutFOehF+2+JmHkei2qSr8eR0LI
   dGu0W3G3Kphs2qrNZILP1oFEs/Ui3eqJkBm2vRJfMxqV41Jz1uOv1tbDN
   RKSxIZadq2v9/01NIz6mbLz5yXnrGRuW9P2bhpuJKhYzNk0PdTr0BdL4O
   A==;
X-CSE-ConnectionGUID: n/T8CA7YQ6+zCL7LKOBQPQ==
X-CSE-MsgGUID: 07IN7GxWSeWWjN7O9gi6iA==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="27890300"
X-IronPort-AV: E=Sophos;i="6.11,195,1725346800"; 
   d="scan'208";a="27890300"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 23:20:00 -0700
X-CSE-ConnectionGUID: rWY0v0PEScycOnyZS0PncQ==
X-CSE-MsgGUID: lJP2v4pdTD+jxbx4oEZ/+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,195,1725346800"; 
   d="scan'208";a="77295359"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 23:20:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 23:19:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 23:19:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 23:19:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 23:19:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iS+b8aNg8QKO9iA/m+JHOSw8FobnXZP226+/Hqkd0HL0+Rlg9KasoUcCsDKUITdqoUUwNt8pDVBURS7mtrxp6MpV4iIkz+dMkLriJsBxe7wDVEIJS+MVKeQXpBsF1uRHVow77VHlIVG6TrOzXHMtZMAZGSmOqmrhpPOD+0Z5ArGJr/zB7Um292qwqV0CfXa5SjksoOMjgEG/Lnge6z/CCTmkxblBrdU2mbEtw25ook421L+m+JLd2ngNFhJ0/nVh1RYR8MxnJMkbLKaPdN3hWd/UlanwbT+8Z2cOhUIENIP5qRzUMmceDLD+z7J3lw5GKGsQx03OmUjTDnxtxqcVQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6KdZ08/Y2jQehore7JeGr5ZZezHfxtoGhDAlFmskno=;
 b=AtWcUKrKQpB5SE6rhiR2hUKetZyuS+i33mZ8iDu1swA9PH9/ELyK5jZwuUk6AQ2nybs4+5KumTlUAfds5vaGevKLmPfo+fKlrF9pWSp/c3rg/C+8MrnsMsqJUXOzE+/Szlx86TYnhqprGq6qe8+m+5ehWpuKJ611ndN1ikYkI+PI/leByBhCRY9hwXv1oSUaXPUecqKSC2B7EFiMndIVXdo0lBYVgjbb/pAX0oian9UxyGahhCo42nsuq1OLzMOV7OOCVTHSJnGOiCii8WP1Ajnj5Eo+l4IWNE20Cb/U1Lnh9ZaTAxEHH3aGfkivjevIzo9D8Ua86rDlsDc/WD8tvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Fri, 11 Oct
 2024 06:19:57 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 06:19:56 +0000
Date: Fri, 11 Oct 2024 14:19:42 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Alexander Aring <aahringo@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <gfs2@lists.linux.dev>,
	<teigland@redhat.com>, <song@kernel.org>, <yukuai3@huawei.com>,
	<agruenba@redhat.com>, <mark@fasheh.com>, <jlbec@evilplan.org>,
	<joseph.qi@linux.alibaba.com>, <gregkh@linuxfoundation.org>,
	<rafael@kernel.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<ocfs2-devel@lists.linux.dev>, <netdev@vger.kernel.org>,
	<vvidic@valentin-vidic.from.hr>, <heming.zhao@suse.com>,
	<lucien.xin@gmail.com>, <donald.hunter@gmail.com>, <aahringo@redhat.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCHv2 dlm/next 10/12] dlm: separate dlm lockspaces per
 net-namespace
Message-ID: <202410111400.130b9d53-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240930201358.2638665-11-aahringo@redhat.com>
X-ClientProxiedBy: SI2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:195::6) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB8210:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0d444a-ed7f-4945-d90c-08dce9bcb9fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H1ifHCQMrraRwvKL9uzoALX1F9RiWmAfTQvIXoIy/diBWOq1Q7E9hJ25VkYc?=
 =?us-ascii?Q?dJ88ciun/VuOugJppNjk2fa2hh9EZYzrNdysZFp/8cJNUSTBoNHcJ5FFr7lU?=
 =?us-ascii?Q?uzoS9a/n7HB7tdAuPmI6C3kzimtfVaYgDeHANPMZJN6TePMA5DRnzyskWFl/?=
 =?us-ascii?Q?L+g8bwnSpH4sOPXMl/a8ejCX8+xwVIBCu96L5sN3Ra96GF34KNpZ1wfLds03?=
 =?us-ascii?Q?2GzFz65ca5K6Qs9xL5u5asJHm7hXsAkztzU75DHsGqMAbmHnKrrgN5DJiEwX?=
 =?us-ascii?Q?HOv77wCTyNrP9N3vaeDmKRUmOakdRYwRN5R9FK3t02qY/Fz2dHwuUiVEAGQz?=
 =?us-ascii?Q?PGpzz3FhgCoExRcf9gFk0Vnxkgb5jcMWgmyuQ8vm41jPT7QWRrFnVbzvazn8?=
 =?us-ascii?Q?0zfx2TwjQ6UIYA5CM2lxVTADCczP/Em6MZWdehobfBp3WscZpSqH562oQfKr?=
 =?us-ascii?Q?d6p+tQ9XcVPQnD1uKq18pMiIdfJQXG5uJ+CFwcojSnVvM5QoGRAYavKpGpSd?=
 =?us-ascii?Q?S+vtjVyClaczfvWcDV503DTCVvXnkOonhe+LzWHlzxPoRo50/BEMWv1MIfN4?=
 =?us-ascii?Q?SS8vyWJE3sGPKOtWyzetdKNZM51ujBI1/EWR37gmdIiE1C2uZ17WUuaGn2vJ?=
 =?us-ascii?Q?RldcG9xbmzUf26gsrBNXLTjfgLAPGsN/OFlVZS25RQj/Vet1/h4ejmDMGVxL?=
 =?us-ascii?Q?9CrvpzIHlyoXtNDkbPWJ6+vTu3mplPHGjvmqIfywgVX1lt9cFLsh8vfxx15e?=
 =?us-ascii?Q?Alv1NtVprtuQWGE42BjnyP89TAAVgGg0ukL2LM8aI20xCO+3ASo9ge6+eMCi?=
 =?us-ascii?Q?VwPJmZeC40SiIwHgz7Od1qflGTQ2tRtBrC7+t1KUEoo6W8rTk8zVqyUYUNSb?=
 =?us-ascii?Q?Om0E0rBlbpI7KbQ4Dvts5lcJFZ9Bj28grZVl4/6MBief+qheudohOdYxzN+u?=
 =?us-ascii?Q?40R6vz4Ot6TLfUkBrZ3qXVGyRxrfZ/ybb9z8Om9sKuHsj4SMEIw7bsUrbe0L?=
 =?us-ascii?Q?8UuaGSevzvs+F75AYU3zXFb9RpVcBGB8H+OF5oJoKPWCrQ7Vhon9N6ecirzu?=
 =?us-ascii?Q?2SJZdJHTQKYC6vNwpyDEFDQ1++fI/ttb8fVRxOxyGWPs8wNbtGT5jhINduHH?=
 =?us-ascii?Q?XePJ95XDSuZ5Yo+WDWKoxfConWS7pH856nc8YH/4Wq1hWhSG/F1lavzvL2L8?=
 =?us-ascii?Q?faPxLwk9GgKcoaYYUejQ9n2fR6cVbF2c/hsr2G7HsEB5UbGJDJPaYD+IM0w?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C4eZibOXCN5+/eUQof6rXj75UIvwaPDTzI7Dhu+CdvrktuhtG+eRRFUzW4Dx?=
 =?us-ascii?Q?wiGK05h0C6RVPvvydVOqf8g6eb5DCrC1t2YbaqmvFQBQi+3tExQRldvJ2AuZ?=
 =?us-ascii?Q?tZAcYzUD+tzrA2A9zMGTu+FyX5jsSaVexyUwZrvkfveSwm1PtjhwQIXFcK5s?=
 =?us-ascii?Q?8IWzTbVxh+hreqW2GtsR1Y8WVkFx1qKvHyMpViA0rVWoJOtbgcHaqJuDKa4q?=
 =?us-ascii?Q?VNxGIj33PhQd1X6QhqsXrnN7yT8iIAYXWAIuiqOFeF2gr9RlrwWRhWi2zMoj?=
 =?us-ascii?Q?EAIQhAc6QahzYXgCseEFPrvnjN4HsGV03lTP9TdeX246C8uppNq1D0/hIZZg?=
 =?us-ascii?Q?/yCPU/EwxuOQp7BKIDn1HjeSgvPH2RXZmv+FvzLKyXXwL4807h/WCNQXup4r?=
 =?us-ascii?Q?cZBfpd+RE018wyzh8vsK0YmFj+w04zujb8Gf5k44ROdvdX+M7m/zjoiLrBoC?=
 =?us-ascii?Q?8FvPyQUAsh8YFnOo8tE3txkL+g1SyKQ0TvPZyFpZSGHpE/4PNBpdUWRcPVer?=
 =?us-ascii?Q?pxsz5GNnKZcxPSAefcbKBK7k4OM2uFjD41JeRHz+pYZv7nZNnuecrWsgbDK3?=
 =?us-ascii?Q?zfHUnu6OQsrKypSBBoZgMnf7TwPietuxFTAyJy1J2Wkc3dp9+2AT4xOiq57L?=
 =?us-ascii?Q?xq8udy6D3D9+48Pproei8huTsTfiSQ1/qrvK9nnt7xQB6Er3Iz9rx6UKfmya?=
 =?us-ascii?Q?bB3KWQJGyqrwsuXK2kJx7KAgNUuMKNSGGOwOOMWv+ZR2PGZzwpSu5BQ4sl9V?=
 =?us-ascii?Q?XF4896LNpiFoqB1/KWeyuKsoooYgR5JnU8mntjJwvWi0EsqPmXvjM4/xuo8w?=
 =?us-ascii?Q?zcjAGnWJblFwVM+Y0RY1ycBNoIUn01c3uIPHYhJcKeD4ExZSliQyF77ri3tC?=
 =?us-ascii?Q?4fxKePZqT/pWbRLttlZCDO+71GyFjChd4PgTbNV5bKPxaFVOP2RUyvhSkrIh?=
 =?us-ascii?Q?6qS4X87d7K3FfIg+CDgFSY2uYpjqHbYneWio0sGJIkGfjqLjlXS/KG+scI5v?=
 =?us-ascii?Q?ccegZkmS9REB6Ct809x4csLMYmkkfVLq4PMs9UHXuhjxdmHdVc/UDKwNEGjh?=
 =?us-ascii?Q?oOAJJBr7HO/TFXEVf1CnDQdLSGScSPkhZywkF1n5S6n7o676lAzhyIWpokXl?=
 =?us-ascii?Q?/NHITizwR2J1YpGJXrWxeCqJEY1GApnoQR11bbWsYsVUDCAhP2ZEf/y5aiel?=
 =?us-ascii?Q?/sotURuC5DZ15+MlLP5duIbXMi5n3jzzI7SliIrmmhOX1JhMMEqYXja6JvKe?=
 =?us-ascii?Q?3jbVPHOWQE6mPtF/jUSP856o/U9bQaKrYWckyZI0iomPfVZs8F/RPVZW5pfz?=
 =?us-ascii?Q?HE3WizkCBB1KMP9eDNljkojBO/s2DFm0mtzVeT5yyOT5LQUth0U8NkLas3TX?=
 =?us-ascii?Q?oOv8kGQf+GA5K5i3+v7IpoW7uNQDGZeZ3RB2iNHlTJuKS7BXCfFr/uu2R8Ob?=
 =?us-ascii?Q?AQzcCwbupNMv/cDOAd/IggB/YjTBpwHlRVArVpnossS0I6ISxrG+vy2h+LoO?=
 =?us-ascii?Q?/XrdG6nL5LcZ0KN5cb3oiS8qN0IHIAqPldciJ8XSyeb2OPfpvTev1V+LsxOS?=
 =?us-ascii?Q?EYW0fMOZhmwwAO8WdD+66DHCEXatTsSQLspT3nEpB8xpAii3STr6MZ6SSO80?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0d444a-ed7f-4945-d90c-08dce9bcb9fa
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 06:19:56.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ViYODtKpkz3b71ZcftulLsXDvuN7V5CI0uZ9+qU5DUM7s+4+QuIL9R4p/fps8O9rp30Drq4llbfumECbOgQcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "fs/dlm/midcomms.c:#RCU-list_traversed_in_non-reader_section" on:

commit: e89c4c2902364b7dda0fda243da1b7e84a1faae5 ("[PATCHv2 dlm/next 10/12] dlm: separate dlm lockspaces per net-namespace")
url: https://github.com/intel-lab-lkp/linux/commits/Alexander-Aring/dlm-introduce-dlm_find_lockspace_name/20241001-041944
base: https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git ad46e8f95e931e113cb98253daf6d443ac244cde
patch link: https://lore.kernel.org/all/20240930201358.2638665-11-aahringo@redhat.com/
patch subject: [PATCHv2 dlm/next 10/12] dlm: separate dlm lockspaces per net-namespace

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-00
	nr_groups: 5



compiler: clang-18
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-------------------------------------------------------------------------+------------+------------+
|                                                                         | 7bd2eb99b7 | e89c4c2902 |
+-------------------------------------------------------------------------+------------+------------+
| fs/dlm/midcomms.c:#RCU-list_traversed_in_non-reader_section             | 0          | 12         |
| fs/dlm/lowcomms.c:#RCU-list_traversed_in_non-reader_section             | 0          | 12         |
+-------------------------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202410111400.130b9d53-lkp@intel.com


[   35.412526][  T331] WARNING: suspicious RCU usage
[   35.412943][  T331] 6.11.0-11738-ge89c4c290236 #1 Not tainted
[   35.413404][  T331] -----------------------------
[   35.413801][  T331] fs/dlm/midcomms.c:1170 RCU-list traversed in non-reader section!!
[   35.414429][  T331]
[   35.414429][  T331] other info that might help us debug this:
[   35.414429][  T331]
[   35.415231][  T331]
[   35.415231][  T331] rcu_scheduler_active = 2, debug_locks = 1
[   35.415867][  T331] 4 locks held by kworker/u8:1/331:
[ 35.416277][ T331] #0: 83de38c4 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:?) 
[ 35.417037][ T331] #1: ed2b9f04 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:?) 
[ 35.417746][ T331] #2: 82eec22c (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net (net/core/net_namespace.c:583) 
[ 35.418427][ T331] #3: eaba3c70 (&dn->nodes_srcu){.+.+}-{0:0}, at: srcu_lock_acquire (include/linux/srcu.h:150) 
[   35.419124][  T331]
[   35.419124][  T331] stack backtrace:
[   35.419618][  T331] CPU: 0 UID: 0 PID: 331 Comm: kworker/u8:1 Not tainted 6.11.0-11738-ge89c4c290236 #1
[   35.420349][  T331] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   35.421318][  T331] Workqueue: netns cleanup_net
[   35.422067][  T331] Call Trace:
[ 35.422612][ T331] dump_stack_lvl (lib/dump_stack.c:122) 
[ 35.423303][ T331] dump_stack (lib/dump_stack.c:129) 
[ 35.423991][ T331] lockdep_rcu_suspicious (kernel/locking/lockdep.c:6803) 
[ 35.424808][ T331] dlm_midcomms_exit (fs/dlm/midcomms.c:?) 
[ 35.425565][ T331] dlm_net_exit (fs/dlm/config.c:70) 
[ 35.426219][ T331] cleanup_net (net/core/net_namespace.c:174 net/core/net_namespace.c:626) 
[ 35.426927][ T331] ? __this_cpu_preempt_check (lib/smp_processor_id.c:67) 
[ 35.427809][ T331] process_one_work (kernel/workqueue.c:3234) 
[ 35.428581][ T331] worker_thread (kernel/workqueue.c:3304 kernel/workqueue.c:3391) 
[ 35.429358][ T331] kthread (kernel/kthread.c:391) 
[ 35.430046][ T331] ? pr_cont_work (kernel/workqueue.c:3337) 
[ 35.430782][ T331] ? kthread_blkcg (kernel/kthread.c:342) 
[ 35.431480][ T331] ? kthread_blkcg (kernel/kthread.c:342) 
[ 35.432219][ T331] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 35.432972][ T331] ret_from_fork_asm (??:?) 
[ 35.433732][ T331] entry_INT80_32 (init_task.c:?) 
[   35.434945][  T331]
[   35.435452][  T331] =============================
[   35.436245][  T331] WARNING: suspicious RCU usage
[   35.437033][  T331] 6.11.0-11738-ge89c4c290236 #1 Not tainted
[   35.440279][  T331] -----------------------------
[   35.442812][  T331] fs/dlm/lowcomms.c:1961 RCU-list traversed in non-reader section!!
[   35.446360][  T331]
[   35.446360][  T331] other info that might help us debug this:
[   35.446360][  T331]
[   35.450959][  T331]
[   35.450959][  T331] rcu_scheduler_active = 2, debug_locks = 1
[   35.454214][  T331] 4 locks held by kworker/u8:1/331:
[ 35.456221][ T331] #0: 83de38c4 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:?) 
[ 35.459107][ T331] #1: ed2b9f04 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:?) 
[ 35.461940][ T331] #2: 82eec22c (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net (net/core/net_namespace.c:583) 
[ 35.464777][ T331] #3: eaba3afc (&dn->connections_srcu){.+.+}-{0:0}, at: srcu_lock_acquire (include/linux/srcu.h:150) 
[   35.472495][  T331]
[   35.472495][  T331] stack backtrace:
[   35.473301][  T331] CPU: 0 UID: 0 PID: 331 Comm: kworker/u8:1 Not tainted 6.11.0-11738-ge89c4c290236 #1
[   35.474444][  T331] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   35.475498][  T331] Workqueue: netns cleanup_net
[   35.475954][  T331] Call Trace:
[ 35.476282][ T331] dump_stack_lvl (lib/dump_stack.c:122) 
[ 35.476700][ T331] dump_stack (lib/dump_stack.c:129) 
[ 35.477272][ T331] lockdep_rcu_suspicious (kernel/locking/lockdep.c:6803) 
[ 35.478275][ T331] dlm_lowcomms_exit (fs/dlm/lowcomms.c:?) 
[ 35.479318][ T331] dlm_midcomms_exit (fs/dlm/midcomms.c:1186) 
[ 35.480266][ T331] dlm_net_exit (fs/dlm/config.c:70) 
[ 35.481123][ T331] cleanup_net (net/core/net_namespace.c:174 net/core/net_namespace.c:626) 
[ 35.481942][ T331] ? __this_cpu_preempt_check (lib/smp_processor_id.c:67) 
[ 35.482925][ T331] process_one_work (kernel/workqueue.c:3234) 
[ 35.483825][ T331] worker_thread (kernel/workqueue.c:3304 kernel/workqueue.c:3391) 
[ 35.484571][ T331] kthread (kernel/kthread.c:391) 
[ 35.485382][ T331] ? pr_cont_work (kernel/workqueue.c:3337) 
[ 35.486288][ T331] ? kthread_blkcg (kernel/kthread.c:342) 
[ 35.487171][ T331] ? kthread_blkcg (kernel/kthread.c:342) 
[ 35.488014][ T331] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 35.488786][ T331] ret_from_fork_asm (??:?) 
[ 35.489648][ T331] entry_INT80_32 (init_task.c:?) 



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241011/202410111400.130b9d53-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

