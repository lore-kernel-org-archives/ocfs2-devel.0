Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB01C2304;
	Tue, 20 Aug 2024 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724175503; cv=none; b=CkDITlBpET8glKs5Eap0h48ec693G89A0PmT6WxdQS5fjRvTCTKImxrs9mGIVrmNcceHth+kUd4gBodI4hsYnXl7Pgv9t9fx1lDyasHwF2HCatadK7+rGROTYiyI7la3uQDJbfAmGIWgx9ZzM6ge+lJWccUCLtGd2Xs3xTGoJWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724175503; c=relaxed/simple;
	bh=EjvuXTL9RY4eoTb19RgzBjMa+cSksThBbZqhx5M18sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgamD5gQGICA5G8bS6dtNFBGCK7vsMgzoFrydBwuZyk6WRIGX6ndcXlXZukA+i8aK6/bfjdOUpS1kSEAUjOQFB1JnPEdKrV97HsMr96EzG//gr5djvI5r/BMRw3MI3YQeYybupQfISj5XIt2oPdqrKXbV21Cf4FdyidulsFnGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YGtpswnz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YGtpswnz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724175502; x=1755711502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EjvuXTL9RY4eoTb19RgzBjMa+cSksThBbZqhx5M18sU=;
  b=YGtpswnzjt5XjxPqJEJHom1YuCkGQQqY8ynQan2VS5N4ruJLUVmvPrNS
   ZmemPlwC0rK+2R2CXT/spwlXe15fZsxjaqMllWUccwvlwHLTkLNZQ3Z+A
   ZmT6XOJHwrz6YSRoMIWkvejmdYMN00cag5YpdfOIdmOhOa5Jm1jtIrbYt
   mf6+jd1h9CvrepJNljcSb+2DEgCX53Dddw+ilJNWFpTFnNG+rYnBC5/Oh
   W25SrpP2h/yg8A4xlzE0CijU3PRg171T0p9oPgCOdGbFXwcvmmkyOlZi9
   I/+0YLgGUDe06k5qK1yBegdNwGj5c6zu/awJNsgE9/VyJh2OsGW3lux/c
   A==;
X-CSE-ConnectionGUID: KGXvWfYRSFOntW55kDwe8Q==
X-CSE-MsgGUID: 0FePTS1mQOSe/jHIL/qu+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="45019412"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="45019412"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 10:38:19 -0700
X-CSE-ConnectionGUID: tDt3CZioSPenDd/CKCawug==
X-CSE-MsgGUID: gJVKAoFgSk2q9I9WF7cSbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="60958615"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 20 Aug 2024 10:37:47 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sgSng-000ASW-1h;
	Tue, 20 Aug 2024 17:37:44 +0000
Date: Wed, 21 Aug 2024 01:37:10 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Aring <aahringo@redhat.com>, teigland@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	gfs2@lists.linux.dev, song@kernel.org, yukuai3@huawei.com,
	agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org,
	rafael@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, netdev@vger.kernel.org,
	vvidic@valentin-vidic.from.hr, heming.zhao@suse.com,
	lucien.xin@gmail.com, aahringo@redhat.com
Subject: Re: [PATCH dlm/next 12/12] gfs2: separate mount context by
 net-namespaces
Message-ID: <202408210153.9Dofqzlb-lkp@intel.com>
References: <20240819183742.2263895-13-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819183742.2263895-13-aahringo@redhat.com>

Hi Alexander,

kernel test robot noticed the following build errors:

[auto build test ERROR on teigland-dlm/next]
[also build test ERROR on next-20240820]
[cannot apply to gfs2/for-next driver-core/driver-core-testing driver-core/driver-core-next driver-core/driver-core-linus linus/master v6.11-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Aring/dlm-introduce-dlm_find_lockspace_name/20240820-024440
base:   https://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git next
patch link:    https://lore.kernel.org/r/20240819183742.2263895-13-aahringo%40redhat.com
patch subject: [PATCH dlm/next 12/12] gfs2: separate mount context by net-namespaces
config: arm-randconfig-003-20240820 (https://download.01.org/0day-ci/archive/20240821/202408210153.9Dofqzlb-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 26670e7fa4f032a019d23d56c6a02926e854e8af)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240821/202408210153.9Dofqzlb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408210153.9Dofqzlb-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: net_ns_type_operations
   >>> referenced by sys.c:65 (fs/gfs2/sys.c:65)
   >>>               fs/gfs2/sys.o:(gfs2_uevent) in archive vmlinux.a
   >>> referenced by sys.c:65 (fs/gfs2/sys.c:65)
   >>>               fs/gfs2/sys.o:(gfs2_sysfs_object_child_ns_type) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
