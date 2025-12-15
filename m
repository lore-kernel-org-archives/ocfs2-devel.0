Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED77D221723;
	Mon, 15 Dec 2025 04:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765773855; cv=none; b=Na+C8Uj5eNbagoODRRSCKota49cvwnKInadVTY37NHUB8KV9aEzOZ7hmMFFeDZPbisNZoajHfYc66nN41m6lnny6LQGSoesrs3+h3e5VJlJ+xMopXrZzsR1GmxuGt21DEN2VuLEG7fnx9oSSs40phlASpL44PZlRu9C5m+uWuu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765773855; c=relaxed/simple;
	bh=3rUeMWsspT5JA1/nTSwKUbICpsYeFHgJDwhM6n1QxQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNNMp1YvBBOuDweJHJp2yNhykaREOXoAHwIcVTJFmeOJ1wmGs4jRJb9KYZ4ikXC7pySbit7ESQq24IONmajj6QxWK7RiMgnKXSzy/n87ussaaZQttn9CNvyLYIwIjFdfcLb34ssllavGQ3myxbr4sL45VojjGMnQCYuEjkjHLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kvVh+Gt8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kvVh+Gt8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765773854; x=1797309854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3rUeMWsspT5JA1/nTSwKUbICpsYeFHgJDwhM6n1QxQs=;
  b=kvVh+Gt8Z4MziXj/cCzDPEY2QPhUAOWW54rgMOX3y2/WYaut2LZqTvb7
   u4mxXCTLCxxjb/Xs5FU4jbCQYksliy8cqqx0a2UJxSum5q/X9ls77vMtt
   r1YF2WGK73XaUeqEqfGrFO3S3K+cAGNKwZm7USwCZf/ohz1SevfYLZwIV
   VAd0Q1GNOQh1T5cpX2/ZtdjRKMRRrHYs30orj7K8Lz4tiTYHDL5Ei7P1i
   QpjtGQdjMaphyDQgfOBoUkvVyQgRu/YW26EkurOSfmwQOaLhcb09rIQI9
   gIwGBy/cAjFS2xgWGyBDnHc1DWtrVP1R9zBu9BdDZ672i1tu92JCfpgpu
   g==;
X-CSE-ConnectionGUID: 2e0H+C+kTKa3Ynmf9zeamw==
X-CSE-MsgGUID: qJjzBvSNQpisXLrTIUJukw==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="66852248"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="66852248"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 20:44:13 -0800
X-CSE-ConnectionGUID: vcDC0i1PQZOoC8UUMBJe5g==
X-CSE-MsgGUID: HXpl1/5oRg69+TOHlvj78g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="228277781"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 14 Dec 2025 20:44:10 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vV0RM-000000009nR-2Iol;
	Mon, 15 Dec 2025 04:44:08 +0000
Date: Mon, 15 Dec 2025 12:44:07 +0800
From: kernel test robot <lkp@intel.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
	heming.zhao@suse.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <202512151210.z9u1Ypu5-lkp@intel.com>
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
config: arc-randconfig-002-20251215 (https://download.01.org/0day-ci/archive/20251215/202512151210.z9u1Ypu5-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512151210.z9u1Ypu5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512151210.z9u1Ypu5-lkp@intel.com/

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
