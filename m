Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A6E33C19E;
	Fri,  3 Apr 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775235042; cv=none; b=rv8BRA1MxKCSKCyfVaFxvunGOnyHQ8GCFcP8pn1BudTQvz0xY+UEQ7W1PlUzSW/js5g4cs0wzOOmcsnVgZRbxxmUAz4tdEAR9pEKQbdsyo3xAzwbV9M8nv28TJpdAwY8jCJq37Q9Y0p4Zc80NOoYQS9SgO3CLeH66U59z5w4dFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775235042; c=relaxed/simple;
	bh=2xqBDOykXD1kBTCGt2dwa2sovl9p54P5tmdA/MPdlfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Osd3iudJ/fsz1Ulck1G6Myt2zn4ENnlJ0p2nP26G1cOHrdFCnQ4mUi6pma2X5IueY+pNjPlzMD7QLpe2bM1rJh0uHDTleWFFHK/p00lQsqSj9qJisSR6Kv6uIUFBT5ecSE8kdcocys8077iYmEs5mK0QE5/n7JKYNeXf85k517I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lfvAlwoQ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lfvAlwoQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775235041; x=1806771041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2xqBDOykXD1kBTCGt2dwa2sovl9p54P5tmdA/MPdlfc=;
  b=lfvAlwoQibRDplOVNQQTbDgoQillwmIczcD+rqrqGtZXTpafVN8+wEFz
   x/tDaETI5HAl3jpfpR7+VI2OxPgaX2/6tJsmzodRllR9aP41BE5KPJeSS
   1fi01VzD/v73/12Lu/szibr/M6xjdZX7EavzsdDh6w65Cig6FC9P8qmEK
   Fbe8YvJGY2NhqgqfP1VYNbduotHBymRDl35HI2ADPd0FFdqYQ0PaYhqOI
   rco07dH0StjgcjCMOIxaTnVbPdzCTJJBIO5iSzE9zc8XbXcDsy9SSD5lX
   713RROP/SoMYzIhIsGSnqd99EardHb+RHZngABag9Di8eycA7ORUf4Hxe
   g==;
X-CSE-ConnectionGUID: hmtpxipRTuyEtnwuQ4Avpg==
X-CSE-MsgGUID: OisQuxd2Toe9nBWerRbMiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="80183167"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="80183167"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 09:50:41 -0700
X-CSE-ConnectionGUID: DtI/I18XSQG81Ka/bjzRHg==
X-CSE-MsgGUID: K895qlu2R0SOuQ2phOp8Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="232227048"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 03 Apr 2026 09:50:38 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8hj9-000000009LR-2bbQ;
	Fri, 03 Apr 2026 16:50:35 +0000
Date: Fri, 3 Apr 2026 18:50:17 +0200
From: kernel test robot <lkp@intel.com>
To: tejas bharambe <tejas.bharambe@outlook.com>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	"mark@fasheh.com" <mark@fasheh.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com" <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-ID: <202604031809.3cnzRidc-lkp@intel.com>
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
[also build test ERROR on linus/master v7.0-rc6]
[cannot apply to next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/tejas-bharambe/ocfs2-fix-use-after-free-in-ocfs2_fault-when-VM_FAULT_RETRY/20260403-161805
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/JH0PR06MB66325344CF84BBC38B2973C38950A%40JH0PR06MB6632.apcprd06.prod.outlook.com
patch subject: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260403/202604031809.3cnzRidc-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260403/202604031809.3cnzRidc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604031809.3cnzRidc-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/ocfs2/mmap.c:41:28: error: use of undeclared identifier 'inode'
      41 |         trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
         |                                   ^
   1 error generated.


vim +/inode +41 fs/ocfs2/mmap.c

    29	
    30	
    31	static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
    32	{
    33		struct vm_area_struct *vma = vmf->vma;
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
