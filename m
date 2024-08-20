Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBD2149005;
	Tue, 20 Aug 2024 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724139628; cv=none; b=SmrbbYP9xNyfHOASDP8ASoP1nIXYFRxyzx4YWlP3eCqlB9XXrK0yFoAZSjslzST02auuumiefjAeEnj5mXUPg9/8vE4Uf4J1XZQZPGGudfOBhSmGbAwBhfz0FJ4W9Kz8o7pMfFUyJXeRsmds85iXPUs0v2k5Irz4Rag0WBpj69M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724139628; c=relaxed/simple;
	bh=hawFFnGsZ8QIvUfjOYbiKz9xBDXapD08x6QGiLvAwPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJJ4JsGoZ2b6oV2Hxh0TRa8gk1Xcjpic3GGo0l/sY6vWYB0ihIR/7CeGl719VL0hwba20gD8kT1+dUL8zvqvdAGgsQu6/X+o9033CgFjweRbphrMNhD4gOCS4yhhQpAJDOinOdLfwkQ4c5NqCiCfiWatBxcgfMCjJgSDiK7HVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frH76/Tv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frH76/Tv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724139627; x=1755675627;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hawFFnGsZ8QIvUfjOYbiKz9xBDXapD08x6QGiLvAwPs=;
  b=frH76/Tv+9ifIDSxpBY3VH9ps0y884t7IF5Ex8vS36mYiIv2KrTqe5Ak
   a68PyDpHcufaHPlMTPcQX3Cgl0T/DeDmKMLNTovUNz503NMPSqwzB3JFw
   +3PAlVG20arGqaehpl1fqE0KaZgC/FjbXJutzb7iJ/sebRYb9QAX4lNmJ
   0a1875KkqgGUs1CpgyYtUxbkQQJhPgxGHCyEMnthvX/HFP8snkBXIK03L
   oMaymjYIkHQTJk08dOndFwDGlCeahbaNbAd/oc4Jcbv51mrKnMiuG8aU7
   MRgy3gxvSHrUcf/P0EpZx0XNsJQLYqyohYQFJ44TYAzl+CRTlqknh2p+1
   g==;
X-CSE-ConnectionGUID: scJOoLEnS3yDGcrImuoP0A==
X-CSE-MsgGUID: lv0Cx7yiRameHnzwWvYjGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="39926456"
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="39926456"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 00:40:25 -0700
X-CSE-ConnectionGUID: u+Uf2G9mTouWtcLGx/72Lw==
X-CSE-MsgGUID: Ni+zAIHISxyEEUBu7A5x+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,161,1719903600"; 
   d="scan'208";a="91406661"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 20 Aug 2024 00:40:21 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sgJTW-0009r2-39;
	Tue, 20 Aug 2024 07:40:18 +0000
Date: Tue, 20 Aug 2024 15:40:09 +0800
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
Subject: Re: [PATCH dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
Message-ID: <202408201509.g1VKeeOl-lkp@intel.com>
References: <20240819183742.2263895-12-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819183742.2263895-12-aahringo@redhat.com>

Hi Alexander,

kernel test robot noticed the following build warnings:

[auto build test WARNING on teigland-dlm/next]
[also build test WARNING on next-20240820]
[cannot apply to gfs2/for-next driver-core/driver-core-testing driver-core/driver-core-next driver-core/driver-core-linus linus/master v6.11-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Aring/dlm-introduce-dlm_find_lockspace_name/20240820-024440
base:   https://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git next
patch link:    https://lore.kernel.org/r/20240819183742.2263895-12-aahringo%40redhat.com
patch subject: [PATCH dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
config: x86_64-buildonly-randconfig-001-20240820 (https://download.01.org/0day-ci/archive/20240820/202408201509.g1VKeeOl-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240820/202408201509.g1VKeeOl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408201509.g1VKeeOl-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/dlm/nldlm.c:195:2: warning: variable 'ls' is used uninitialized whenever 'for' loop exits because its condition is false [-Wsometimes-uninitialized]
     195 |         list_for_each_entry(ls_iter, &dn->lockspaces, list) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:779:7: note: expanded from macro 'list_for_each_entry'
     779 |              !list_entry_is_head(pos, head, member);                    \
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/dlm/nldlm.c:202:7: note: uninitialized use occurs here
     202 |         if (!ls) {
         |              ^~
   fs/dlm/nldlm.c:195:2: note: remove the condition if it is always true
     195 |         list_for_each_entry(ls_iter, &dn->lockspaces, list) {
         |         ^
   include/linux/list.h:779:7: note: expanded from macro 'list_for_each_entry'
     779 |              !list_entry_is_head(pos, head, member);                    \
         |              ^
   fs/dlm/nldlm.c:185:23: note: initialize the variable 'ls' to silence this warning
     185 |         struct dlm_cfg_ls *ls, *ls_iter = NULL;
         |                              ^
         |                               = NULL
>> fs/dlm/nldlm.c:918:11: warning: variable 'log_level' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
     918 |         else if (dn->config.ci_log_debug)
         |                  ^~~~~~~~~~~~~~~~~~~~~~~
   fs/dlm/nldlm.c:921:50: note: uninitialized use occurs here
     921 |         rv = nla_put_u32(skb, NLDLM_CFG_ATTR_LOG_LEVEL, log_level);
         |                                                         ^~~~~~~~~
   fs/dlm/nldlm.c:918:7: note: remove the 'if' if its condition is always true
     918 |         else if (dn->config.ci_log_debug)
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
     919 |                 log_level = NLDLM_LOG_LEVEL_DEBUG;
   fs/dlm/nldlm.c:868:20: note: initialize the variable 'log_level' to silence this warning
     868 |         uint32_t log_level;
         |                           ^
         |                            = 0
   2 warnings generated.


vim +195 fs/dlm/nldlm.c

   181	
   182	static int nldlm_get_ls(struct sk_buff *msg, struct genl_info *info)
   183	{
   184		struct dlm_net *dn = dlm_pernet(sock_net(msg->sk));
 > 185		struct dlm_cfg_ls *ls, *ls_iter = NULL;
   186		char lsname[DLM_LOCKSPACE_LEN];
   187		struct sk_buff *skb;
   188		int rv;
   189	
   190		rv = nldlm_parse_ls(info->attrs[NLDLM_ATTR_LS], lsname);
   191		if (rv < 0)
   192			return rv;
   193	
   194		mutex_lock(&dn->cfg_lock);
 > 195		list_for_each_entry(ls_iter, &dn->lockspaces, list) {
   196			if (!strncmp(ls_iter->name, lsname, DLM_LOCKSPACE_LEN)) {
   197				ls = ls_iter;
   198				break;
   199			}
   200		}
   201	
   202		if (!ls) {
   203			rv = -ENOENT;
   204			goto err;
   205		}
   206	
   207		skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
   208		if (!skb) {
   209			rv = -ENOMEM;
   210			goto err;
   211		}
   212	
   213		rv = __nldlm_get_ls(skb, ls, info->snd_portid,
   214				    info->snd_seq, NULL, 0);
   215		if (rv < 0) {
   216			nlmsg_free(skb);
   217			goto err;
   218		}
   219	
   220		rv = genlmsg_reply(skb, info);
   221	
   222	err:
   223		mutex_unlock(&dn->cfg_lock);
   224		return rv;
   225	}
   226	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
