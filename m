Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B43312819;
	Mon, 15 Dec 2025 11:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765797840; cv=none; b=fRFQkU1omORJxFnu6Byo1J8BRipmq8jo0/Zh/AOwpqHUFZu65d3AJ8oxAZ3gupxbWWdLQSnbIkMeVTr4D/L1ZyeGhT2z4r6o4CnWEP6/dBETfqPdaP04bqDCvkHEkHm8PDeksdwXWX/kE1gjsGcEqVLw69XfG+jkmxChph1E36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765797840; c=relaxed/simple;
	bh=lP5M/h8i3RU8FWBPHXbkD6Ak8tUSX62HiWC5oG4my7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRhmz+h/aFL3pRfYwvDsFVZvu5g60GxQS2QSCD+aKb/DSfD0gm2/qhaRXS8K9nzKTcOJs/FT2vTN2SZFwPMq+JvvCEJ0ZGbzlp5zHnPrIzhdieBN0oNZ9W3rnz3jbQWcjj2BSnQZgeduIulwTbo/JOoUXe5uIGKgOMgSmrF/ecU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MTYKegOf; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MTYKegOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765797839; x=1797333839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lP5M/h8i3RU8FWBPHXbkD6Ak8tUSX62HiWC5oG4my7Q=;
  b=MTYKegOf6B3ilW7iTvXXW4q0n1rgR9fVpRcdosb5Fc8+K+bI6mdmZ8zZ
   rpYB4t4cQUaQNEV0nCLE1vCD8cDL1IK10c3jrWaZGwZoMsiOMC5brkpdR
   alj3z4nxmj8dU0sDwrRewHMplSo70cOdxQ+uRMYWB8f1aRf/6oPhhbkmT
   yyB4Y3r1G2brPeoO9vuoDyf0cGtNypXb59Lq5VyWdeqP7cKTHqpQTFC89
   cVGtrA8Q5ytMOKVOdiJdWjDe7ngEJnbvVYuNStGM/0JzOpAzq+CahAAW/
   UJw7pHBP46ntecgr2Y0RzuAlnItv0qVvjE+Tef1UJNeSWvO/ifyXhTkYJ
   Q==;
X-CSE-ConnectionGUID: g13mJrPrRdCNtnx+pY6D+g==
X-CSE-MsgGUID: RStL1PoyS0CCevpqj6DmhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="78402427"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="78402427"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 03:23:58 -0800
X-CSE-ConnectionGUID: Bnx+FklITVm11gQa5xYNcg==
X-CSE-MsgGUID: 4IoYhcPLTTKLMg3Wyc4S+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="197316607"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 15 Dec 2025 03:23:56 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vV6gE-000000002dE-0l0h;
	Mon, 15 Dec 2025 11:23:54 +0000
Date: Mon, 15 Dec 2025 12:22:55 +0100
From: kernel test robot <lkp@intel.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
	heming.zhao@suse.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Re: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Message-ID: <202512151240.MwIXYwyy-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251215/202512151240.MwIXYwyy-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512151240.MwIXYwyy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512151240.MwIXYwyy-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/ocfs2/slot_map.c:48:31: error: expected ';' after top level declarator
      48 |                                           struct buffer_head *bh)
         |                                                                  ^
         |                                                                  ;
   1 error generated.


vim +48 fs/ocfs2/slot_map.c

    42	
    43	
    44	static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
    45					    unsigned int node_num);
    46	
    47	static int ocfs2_validate_slot_map_block(struct super_block *sb,
  > 48						  struct buffer_head *bh)
    49	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
