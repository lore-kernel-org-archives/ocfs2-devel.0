Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7226A394787;
	Fri,  3 Apr 2026 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238763; cv=none; b=ZIzOEHONkNu1s9mhD525P1aQlyxQCJkNzdpZxtNXN0/icyTZoTSpyT1kvTQbgY1uT4KTmMNsEm+kg/pB2wxhMvil7wlWFlh7z9UAj4fi5Pw3UGLIWd/LozsaxZTf0cCv/th+vEZATPKDFSYdQlPwmqQR/IujjVN5U5DWQ9vby8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238763; c=relaxed/simple;
	bh=kfr2zWYqcYI0zSpaJhjc9tAQEZyzj04Pgw4CGW7kKJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2a0fwZzNiHmN6flO2ecSJAfXULc1GIvWXoHmXbeb1UnGqqTsZDQqMn79HaLS9rlPd4JNi8Cco6K+V6t3K7tPYjmEXigrIeOrsuvoL1BQaxmSIbLxIwHlLPRTYhqKSy4O5W1WyN9sXOM3m0ZUpmt6DIT5n8TP7xIwJ4P085g97A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HM1OcqeA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HM1OcqeA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775238761; x=1806774761;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kfr2zWYqcYI0zSpaJhjc9tAQEZyzj04Pgw4CGW7kKJ4=;
  b=HM1OcqeAvhGiA7M7KlMjO9QA/q6gxd7MHm2wM60LCa/sbVPoRmmanZK4
   SL9IjOfY3r5t8keXxK0Waw8OcDIQ5geX2y7RMk2+h8p6e2mtIP+d8vZas
   iVbK2wSiPZyX7NGRrkvhcvo3Wn3hDnRpYz/bqyNM9dJSyNyfzl0XIWunE
   EofzrrEOqucxvPraW5Hdw0Shfg8JtyqqB96Xt0G81pjORBU10VRhs27y0
   o0ygatljLkUc8RYppYo7evY1MXeOzKZZ7ydQfdHaontE8pxPY6CUt80DK
   f7Irv8XZFrD7QTC3Vf3kQ3oW/9Z6IV52jTM88WK/x1/Iscjf2zyItnmJn
   w==;
X-CSE-ConnectionGUID: 5DIoSaa1QCqWzd612nbdLA==
X-CSE-MsgGUID: 1dF3/7pxTBG2qMDZSv9MTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76186475"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76186475"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 10:52:41 -0700
X-CSE-ConnectionGUID: ZqWwV0ofR3+WQ/NkbIG6rg==
X-CSE-MsgGUID: oqRS3P2BRaqTu76GG2Wq8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="250384002"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 03 Apr 2026 10:52:38 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8ihA-000000009M5-23oF;
	Fri, 03 Apr 2026 17:52:36 +0000
Date: Fri, 3 Apr 2026 19:51:38 +0200
From: kernel test robot <lkp@intel.com>
To: tejas bharambe <tejas.bharambe@outlook.com>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, "mark@fasheh.com" <mark@fasheh.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com" <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-ID: <202604031948.fsuptUtV-lkp@intel.com>
References: <JH0PR06MB66325344CF84BBC38B2973C38950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JH0PR06MB66325344CF84BBC38B2973C38950A@JH0PR06MB6632.apcprd06.prod.outlook.com>

Hi tejas,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.16-rc1]
[cannot apply to next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/tejas-bharambe/ocfs2-fix-use-after-free-in-ocfs2_fault-when-VM_FAULT_RETRY/20260403-161805
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/JH0PR06MB66325344CF84BBC38B2973C38950A%40JH0PR06MB6632.apcprd06.prod.outlook.com
patch subject: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
config: x86_64-rhel-9.4-func (https://download.01.org/0day-ci/archive/20260403/202604031948.fsuptUtV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260403/202604031948.fsuptUtV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604031948.fsuptUtV-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   fs/ocfs2/mmap.c: In function 'ocfs2_fault':
>> fs/ocfs2/mmap.c:41:35: error: 'inode' undeclared (first use in this function)
      41 |         trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
         |                                   ^~~~~
   fs/ocfs2/mmap.c:41:35: note: each undeclared identifier is reported only once for each function it appears in
>> fs/ocfs2/mmap.c:33:32: warning: unused variable 'vma' [-Wunused-variable]
      33 |         struct vm_area_struct *vma = vmf->vma;
         |                                ^~~


vim +/inode +41 fs/ocfs2/mmap.c

    29	
    30	
    31	static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
    32	{
  > 33		struct vm_area_struct *vma = vmf->vma;
    34		sigset_t oldset;
    35		vm_fault_t ret;
    36	
    37		ocfs2_block_signals(&oldset);
    38		ret = filemap_fault(vmf);
    39		ocfs2_unblock_signals(&oldset);
    40	
  > 41		trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
    42				  vmf->page, vmf->pgoff);
    43		return ret;
    44	}
    45	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
