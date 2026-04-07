Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D5374E6F;
	Tue,  7 Apr 2026 03:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775533947; cv=none; b=urD9La4ttIpJ3vTWfWnabPUCv6ijgrEHN4LeXiPhTLYRloiTnNz2ZXv0UxRqirzjTXck0NibxwBWtVdMPBdStdDAnfoOH2ugsrFzNUQavrxpziXH8EcfWFWia0MZAnUTCzA6fdK1XIBMjnu6KC8iEMCCwe2Usqai2HxRhME50tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775533947; c=relaxed/simple;
	bh=sPcWkKf8R/XYvpEu6cJb2c0nkBMV3iFRxgmhJvmU66s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LMHQVr2MM/7tfyofnavb0aANPlsOScz/vX1t5EaGh52XkwuKmcYO6hDLNpUzhAicpTNrGWrLI48sKK/AfcsG+TOwW7npp75pT4BRQrMH2GU67CvgNbrBuAn0Yfa30ShriqkXka0PEhtc6HeWBPNvcIZ5/B3HXT6tEymuDABsG/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ByfN9O0z; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ByfN9O0z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775533945; x=1807069945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sPcWkKf8R/XYvpEu6cJb2c0nkBMV3iFRxgmhJvmU66s=;
  b=ByfN9O0zuKDTF/Dhd0u25gP2hQQYDmv3n86H25wckHMHZs9XFFtv0gWd
   1jePA4Q5vOK1uzHHtoGlzaEwgsYOowgnmoTaozUsHiSQZh6vq22l1T9iL
   qlTkTi4QiH9N933yAV/EQJhAB/VM+BEqS7hMfUx55B2vHOY0b989xhl/1
   mvqi4/2ETGpvfrmC4SWaFVLVa2ZPnWUQ7fhzHqbl6CvGo7mXkH/sGh5Eb
   SQ2IO1xPHKKpj7s0vbkwm9FBKeAGXxGQmOLvognvHZcK6ZBEhZzHBzjBR
   MnmIv3iNky8tu76DmX4Oe6APD7BpKQyMYGzy0u1pu6gGWEvklEN21WctD
   A==;
X-CSE-ConnectionGUID: jODUtotrRQmtNzIvqATAOw==
X-CSE-MsgGUID: zZWJUsT6TKatgUAGl3jPOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="80080626"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="80080626"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 20:52:24 -0700
X-CSE-ConnectionGUID: zUxJpU63R5yQ+2YMS8tvsw==
X-CSE-MsgGUID: tO7zhzHLQVOSR5kWda98Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="227994505"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 06 Apr 2026 20:52:22 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xUA-0000000002X-2bIP;
	Tue, 07 Apr 2026 03:52:18 +0000
Date: Tue, 7 Apr 2026 11:51:34 +0800
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
Message-ID: <202604040621.obNS19yW-lkp@intel.com>
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
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20260404/202604040621.obNS19yW-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260404/202604040621.obNS19yW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604040621.obNS19yW-lkp@intel.com/

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
