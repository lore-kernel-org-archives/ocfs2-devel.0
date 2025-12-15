Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4772330B28;
	Mon, 15 Dec 2025 11:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765798802; cv=none; b=WM3H0G0BjEllrMKPE7Pa3ScBdy9ilW8k7t7eiAR6Cun3PaqBProqrDROPhpeGeG+z4xfP8OGZ9R4VvCme4kMI5KyFQ4Jl7CPB9yPtSvBOgwndRr7HEFEnVAIIPxuQmfl26ai2CwTR2R3dLfXwA3J7bZUxM0ZBwyXYMBKSJCazRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765798802; c=relaxed/simple;
	bh=4hKyxKlq732bbjyk4KLPYDhlJcnTgAnQjfkooKn8bUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuqvR5yEaRwftbFcRkx6jwRb35Vr0DYB5iwIADsY9es4eJAefwR/1j+0RQ99n9MB3yFKsbHMcMe0i5C7C+zoKqADAMvcLfvVsJLpCLgh3/n6X5BHpM6N3verRTZVPHO/8EzQkm8Q7cQKyPicY7ykf688ofTxwl2Eq68WfX9/hwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ldDgWKIW; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ldDgWKIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765798800; x=1797334800;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4hKyxKlq732bbjyk4KLPYDhlJcnTgAnQjfkooKn8bUw=;
  b=ldDgWKIWsQpAsY79Ecey3ZL2gEP+4jd8mSzcoOySPck+PVYoY8Cmihua
   bIPrV/AM9kNXDvrg5kM87HPNEztuzlXi86f57k3kS5Pn6qt+d0X79NtvL
   1azGb38w4u2nq0ko2stE8OdOLFMOv0RD5W0rnot6L7nWxoqy6D7I97o+T
   1VV4GDHf5MWHyGRewzHFMOEIpc1Ecq3ysudLx5ixMmVtdhhe46OYe96v+
   hxvluuZ9L6A17hAZxOaxpKzeAWxbqtaTEWdEIO2u+0d+ZhgyDa6fczEKD
   bIIPXJevpyGUzKc4vU/ENTOwmMGLDKiZZGAm5me3XBV9mmP0p4rY484Be
   w==;
X-CSE-ConnectionGUID: CT9zlUH+QSqfasCDnanMSA==
X-CSE-MsgGUID: x21N7KTIQt23xY5DDl/14Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="85108478"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="85108478"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 03:40:00 -0800
X-CSE-ConnectionGUID: Q1JvZib5T4Wx0htHmxFR0A==
X-CSE-MsgGUID: IIx5jaAURMqWTV/U4GSr0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="221085298"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 15 Dec 2025 03:39:57 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vV6vi-000000002dQ-1ILT;
	Mon, 15 Dec 2025 11:39:54 +0000
Date: Mon, 15 Dec 2025 12:39:06 +0100
From: kernel test robot <lkp@intel.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
	heming.zhao@suse.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <202512151209.PXAJgMVX-lkp@intel.com>
References: <20251214192047.34811-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214192047.34811-1-activprithvi@gmail.com>

Hi Prithvi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Prithvi-Tambewagh/Syzbot-test-for-v3-ocfs2-fix-kernel-BUG-in-ocfs2_write_block/20251215-032310
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251214192047.34811-1-activprithvi%40gmail.com
patch subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251215/202512151209.PXAJgMVX-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512151209.PXAJgMVX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512151209.PXAJgMVX-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   fs/ocfs2/slot_map.c: In function 'ocfs2_validate_slot_map_block':
>> fs/ocfs2/slot_map.c:52:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
      52 | {
         | ^
   fs/ocfs2/slot_map.c:59:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
      59 | {
         | ^
   fs/ocfs2/slot_map.c:68:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
      68 | {
         | ^
   fs/ocfs2/slot_map.c:93:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
      93 | {
         | ^
   fs/ocfs2/slot_map.c:108:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     108 | {
         | ^
   fs/ocfs2/slot_map.c:120:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     120 | {
         | ^
   fs/ocfs2/slot_map.c:154:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     154 | {
         | ^
   fs/ocfs2/slot_map.c:172:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     172 | {
         | ^
   fs/ocfs2/slot_map.c:190:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     190 | {
         | ^
   fs/ocfs2/slot_map.c:215:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     215 | {
         | ^
   fs/ocfs2/slot_map.c:239:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     239 | {
         | ^
   fs/ocfs2/slot_map.c:255:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     255 | {
         | ^
   fs/ocfs2/slot_map.c:276:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     276 | {
         | ^
   fs/ocfs2/slot_map.c:289:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     289 | {
         | ^
   fs/ocfs2/slot_map.c:305:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     305 | {
         | ^
   fs/ocfs2/slot_map.c:326:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     326 | {
         | ^
   fs/ocfs2/slot_map.c:341:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     341 | {
         | ^
   fs/ocfs2/slot_map.c:361:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     361 | {
         | ^
   fs/ocfs2/slot_map.c:425:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     425 | {
         | ^
   fs/ocfs2/slot_map.c:464:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     464 | {
         | ^
   fs/ocfs2/slot_map.c:472:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     472 | {
         | ^
   fs/ocfs2/slot_map.c:525:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
     525 | {
         | ^
>> fs/ocfs2/slot_map.c:546: error: expected '{' at end of input
>> fs/ocfs2/slot_map.c:545:1: warning: no return statement in function returning non-void [-Wreturn-type]
     545 | }
         | ^
   fs/ocfs2/slot_map.c: At top level:
>> fs/ocfs2/slot_map.c:44:12: warning: '__ocfs2_node_num_to_slot' declared 'static' but never defined [-Wunused-function]
      44 | static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> fs/ocfs2/slot_map.c:47:12: warning: 'ocfs2_validate_slot_map_block' defined but not used [-Wunused-function]
      47 | static int ocfs2_validate_slot_map_block(struct super_block *sb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +52 fs/ocfs2/slot_map.c

d85b20e4b300ed Joel Becker       2008-02-01  42  
d85b20e4b300ed Joel Becker       2008-02-01  43  
fc881fa0d59596 Joel Becker       2008-02-01 @44  static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
fc881fa0d59596 Joel Becker       2008-02-01  45  				    unsigned int node_num);
fc881fa0d59596 Joel Becker       2008-02-01  46  
39ad33650c4c83 Prithvi Tambewagh 2025-12-15 @47  static int ocfs2_validate_slot_map_block(struct super_block *sb,
39ad33650c4c83 Prithvi Tambewagh 2025-12-15  48  					  struct buffer_head *bh)
39ad33650c4c83 Prithvi Tambewagh 2025-12-15  49  
fc881fa0d59596 Joel Becker       2008-02-01  50  static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
fc881fa0d59596 Joel Becker       2008-02-01  51  				  int slot_num)
fc881fa0d59596 Joel Becker       2008-02-01 @52  {
fc881fa0d59596 Joel Becker       2008-02-01  53  	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
fc881fa0d59596 Joel Becker       2008-02-01  54  	si->si_slots[slot_num].sl_valid = 0;
fc881fa0d59596 Joel Becker       2008-02-01  55  }
fc881fa0d59596 Joel Becker       2008-02-01  56  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
