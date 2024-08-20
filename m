Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9D1990B3;
	Tue, 20 Aug 2024 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724165027; cv=none; b=hP87ZboUpHiAjRbMRfo/nW+CTMDfkh87OXsccjPsuNF5Wp7u+3jYoPLCL9N7U0LKHoaxWu7HTcc5BRh+8bBlOPPtl97i8mvB9Ka4fVcDO36RSbUQ7Jn15I9Add/XoN+fnfsGyK03h4zInw5GnCsFz2CnmgpLfA7Jv9knjECG9Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724165027; c=relaxed/simple;
	bh=khzBjM6tTTIrfEx7SUEq8d1H8tHgDTjNBHiBaWajyRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJ7WlWIkCjspn7+tS7YP1X1KSVjH9Am7Jvg1gCW6YQyIqEek1emYOfUOWsH3mRkUxt/q1Dt4Xs/jbbdUwm/C52hhUlmHEoh1zX4X53YLZ0Oz9J+8DnUT+KfI5mS6GwUyC/qokiwAqRWlWideTM4EnGYkM7VM3LaWGboKmSdR4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwhfqlfs; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwhfqlfs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724165026; x=1755701026;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=khzBjM6tTTIrfEx7SUEq8d1H8tHgDTjNBHiBaWajyRc=;
  b=dwhfqlfsTwgv66J/uD0UjcgBcKZlA7pE8zeaJSy0Uoq3y+gMEvhXqUJT
   ZR9sDi52M75R1skAErNi8H/A0fZwdh6/JAfm5BNYnO3+P8nMZGdeJfqkb
   wuva8yZlS+LlxdbD/0Nu47CgGks9MTtmMU6L6cQ2Dwt3qzMtuIkuSY9IE
   KoFc3CIr0mes2KjlpgXbPHzfPV45ZYYxS1eu2eSNt81N21cOREg4sFKUv
   +01zmmXfH8Q2MYFlpZTUyM+1Ca71AtZKh62udahSApm+gObRLHdbCz/fy
   VhOKI2bE4iI/OKixf/4CNb4x7Z7gfs82eIPuVDa9oSbVtE0jNj9cHvWIx
   Q==;
X-CSE-ConnectionGUID: 4pn48BzfTdKiI2GPt6dl4Q==
X-CSE-MsgGUID: EKHEZfb4QIK5IUZ3a1QqXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="26221534"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="26221534"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 07:43:45 -0700
X-CSE-ConnectionGUID: y+2QOYKjTgKIjxm9GBuLOA==
X-CSE-MsgGUID: m0LGFuy+T1WnGhIUGLeoQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="60812367"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Aug 2024 07:43:41 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sgQ5C-000AIY-1h;
	Tue, 20 Aug 2024 14:43:38 +0000
Date: Tue, 20 Aug 2024 22:42:59 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Aring <aahringo@redhat.com>, teigland@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, gfs2@lists.linux.dev, song@kernel.org,
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr,
	heming.zhao@suse.com, lucien.xin@gmail.com, aahringo@redhat.com
Subject: Re: [PATCH dlm/next 12/12] gfs2: separate mount context by
 net-namespaces
Message-ID: <202408202240.cavJRcbt-lkp@intel.com>
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
config: sh-randconfig-001-20240820 (https://download.01.org/0day-ci/archive/20240820/202408202240.cavJRcbt-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240820/202408202240.cavJRcbt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408202240.cavJRcbt-lkp@intel.com/

All errors (new ones prefixed by >>):

   sh4-linux-ld: fs/gfs2/sys.o: in function `gfs2_sysfs_object_child_ns_type':
>> fs/gfs2/sys.c:66:(.text+0x64): undefined reference to `net_ns_type_operations'
   sh4-linux-ld: fs/gfs2/sys.o: in function `gfs2_kobj_namespace':
>> fs/gfs2/sys.c:407:(.text+0x74): undefined reference to `init_net'


vim +66 fs/gfs2/sys.c

    60	
    61	/* gfs2 sysfs is separated by net-namespaces */
    62	static const struct kobj_ns_type_operations *
    63	gfs2_sysfs_object_child_ns_type(const struct kobject *kobj)
    64	{
    65		return &net_ns_type_operations;
  > 66	}
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
