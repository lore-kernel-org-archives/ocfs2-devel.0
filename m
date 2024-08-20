Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15D4158861
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724181734; cv=none; b=XkwqkYAzxKqHD+19Cah3Q9caqxLxzaq3BbXqrSymD5vGnp1yjhzKnEhU5xxW4vuNXSOrhGJEHaw7wlkQ+9Tvf1zZrzUIBlDcjTCm6Sh6U5O1SKJpVugZlghsRB6UJDa44EwcQZvX1HW2wsKXYo2/sA4KMLnnLn0n2e3ucf+A/4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724181734; c=relaxed/simple;
	bh=BpPOfDmirINhx2FeN9v389nMMWzGfbW4wtOzqy53by0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=l8AhNdHjVJr6N3mcLDfvR/4hnXgpnHvtP1hqprcNvpHXjcISM4a8PB43jVsbufMcggIluwWUzD9XfPamARiMrqpf05FwecGhxXyqx4WHnsMXODKDTiEfxo8Q0p2TYadLvMf0ySjHqN1NrSPl7u0sUea3PpWYyYxoImDL2z1+yFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CXQ4C9ac; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CXQ4C9ac"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52f00ad303aso7586953e87.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 12:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724181731; x=1724786531; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5Vgh7cIhAR8EzOC5rIRmEerU1CHjbVHuOqeMf4SYoY=;
        b=CXQ4C9ack/zOJ0aDMA7s7UlvLpOTGdo8ljYywC22Iv8yubp3gedE9yPEph9Bwjb8VZ
         CO9VimynjZkeM5258+feN8bevwEj4T3XYp51CF0eZhAvwgV2vPJ+J+SWl9Tul2ZUzGEJ
         v6hNdpUfaHveSfUkqf89RVcAa0XU1x9zrpZsbiX4iODuEhCajN/1QSlERSLm4trGKeF3
         oUYPewPs9A5kPnoJjpbTUgCqsyQifGEsx9lw8jIu2YkUiVrd/bDuW7O9l+SkRGlOvibX
         DQnEHHgLO04LUFKyjR+fNmiNpdtY//oFa2PeEIk4GZyo7qS5j001yd/DPPTyAeow0DOx
         Vg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724181731; x=1724786531;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s5Vgh7cIhAR8EzOC5rIRmEerU1CHjbVHuOqeMf4SYoY=;
        b=vUxs9PuzdM37h7I3hiJj/lH2ZASKT8k9/F6adC5dsLrFcnPazRllscbdjKLU0tI1F7
         NYNbYUcEuYiJm5ibwgLmR6n6n5eh+K4zq5tt1Z7hjFi4jfyBjYKlBq0lt9/vshFQUfuo
         vf01xMRtzDLCXE6uAjOBj/slZg8RiSZRIzzU2U29eDSR3OvKBlr36sAKpyz2E/KF6UDI
         ma6Qy7IFccuqVxz42oRAQ5DIXZc20lYd4wVkpY2Biy/EZ7hOCNhxd3YV5I3urUSXmyMf
         HeqlLSyEkgzZgVgXKsukO+2CcW0tgRiGOW2Ryf5jLUgylUmHjcG01UUmW1fih35U+hJv
         cpnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXn29xuFLfGAWJ1RvfSrpPrG2wLndAC1gTA/tPB3afVvQww0KXkxfFHUMiB/9u1cq++zdl4rcifx20nVw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzttBFG2DnfAo1qGCE8+bAe/9w9e4L1hYu04TkptMiM7O3avvwu
	XAyC/5Wip1kGUa5GNMP4hwh3+MA/sWvzKc03IUwPrOyfFGgkTpaQHjBknoWShCw=
X-Google-Smtp-Source: AGHT+IHf7Tbewe2gDUqpiwgN6v47D7zLV+pEDL7AQ0VkyE9qIIIroi+fCDpfoFTJLhwZIOCQ0RIEIA==
X-Received: by 2002:a05:6512:230a:b0:52c:8aa6:4e9d with SMTP id 2adb3069b0e04-5331c6b010bmr11047307e87.29.1724181730489;
        Tue, 20 Aug 2024 12:22:10 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838396d0cdsm799992266b.219.2024.08.20.12.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 12:22:09 -0700 (PDT)
Date: Tue, 20 Aug 2024 22:22:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
	teigland@redhat.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, gfs2@lists.linux.dev,
	song@kernel.org, yukuai3@huawei.com, agruenba@redhat.com,
	mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr,
	heming.zhao@suse.com, lucien.xin@gmail.com, aahringo@redhat.com
Subject: Re: [PATCH dlm/next 10/12] dlm: separate dlm lockspaces per
 net-namespace
Message-ID: <2a99ef8c-9475-4843-87e7-c8f03c756e2b@stanley.mountain>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819183742.2263895-11-aahringo@redhat.com>

Hi Alexander,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Aring/dlm-introduce-dlm_find_lockspace_name/20240820-024440
base:   https://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git next
patch link:    https://lore.kernel.org/r/20240819183742.2263895-11-aahringo%40redhat.com
patch subject: [PATCH dlm/next 10/12] dlm: separate dlm lockspaces per net-namespace
config: x86_64-randconfig-161-20240820 (https://download.01.org/0day-ci/archive/20240821/202408210031.QCBHr27k-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202408210031.QCBHr27k-lkp@intel.com/

New smatch warnings:
fs/dlm/lock.c:4989 dlm_receive_buffer() error: we previously assumed 'ls' could be null (see line 4988)


vim +/ls +4989 fs/dlm/lock.c

bde0f4dba584ae Alexander Aring 2024-08-19  4961  void dlm_receive_buffer(struct dlm_net *dn, const union dlm_packet *p,
bde0f4dba584ae Alexander Aring 2024-08-19  4962  			int nodeid)
c36258b5925e6c David Teigland  2007-09-27  4963  {
1151935182b40b Alexander Aring 2023-08-01  4964  	const struct dlm_header *hd = &p->header;
c36258b5925e6c David Teigland  2007-09-27  4965  	struct dlm_ls *ls;
c36258b5925e6c David Teigland  2007-09-27  4966  	int type = 0;
c36258b5925e6c David Teigland  2007-09-27  4967  
c36258b5925e6c David Teigland  2007-09-27  4968  	switch (hd->h_cmd) {
c36258b5925e6c David Teigland  2007-09-27  4969  	case DLM_MSG:
00e99ccde75722 Alexander Aring 2022-04-04  4970  		type = le32_to_cpu(p->message.m_type);
c36258b5925e6c David Teigland  2007-09-27  4971  		break;
c36258b5925e6c David Teigland  2007-09-27  4972  	case DLM_RCOM:
2f9dbeda8dc04b Alexander Aring 2022-04-04  4973  		type = le32_to_cpu(p->rcom.rc_type);
c36258b5925e6c David Teigland  2007-09-27  4974  		break;
c36258b5925e6c David Teigland  2007-09-27  4975  	default:
c36258b5925e6c David Teigland  2007-09-27  4976  		log_print("invalid h_cmd %d from %u", hd->h_cmd, nodeid);
c36258b5925e6c David Teigland  2007-09-27  4977  		return;
c36258b5925e6c David Teigland  2007-09-27  4978  	}
c36258b5925e6c David Teigland  2007-09-27  4979  
3428785a65dabf Alexander Aring 2022-04-04  4980  	if (le32_to_cpu(hd->h_nodeid) != nodeid) {
c36258b5925e6c David Teigland  2007-09-27  4981  		log_print("invalid h_nodeid %d from %d lockspace %x",
3428785a65dabf Alexander Aring 2022-04-04  4982  			  le32_to_cpu(hd->h_nodeid), nodeid,
3428785a65dabf Alexander Aring 2022-04-04  4983  			  le32_to_cpu(hd->u.h_lockspace));
c36258b5925e6c David Teigland  2007-09-27  4984  		return;
c36258b5925e6c David Teigland  2007-09-27  4985  	}
c36258b5925e6c David Teigland  2007-09-27  4986  
bde0f4dba584ae Alexander Aring 2024-08-19  4987  	ls = dlm_find_lockspace_global(dn, le32_to_cpu(hd->u.h_lockspace));
c36258b5925e6c David Teigland  2007-09-27 @4988  	if (!ls) {
bde0f4dba584ae Alexander Aring 2024-08-19 @4989  		log_limit(ls, "dlm: invalid lockspace %u from %d cmd %d type %d\n",
                                                                          ^^
ls is NULL here so this doesn't work.

3428785a65dabf Alexander Aring 2022-04-04  4990  			  le32_to_cpu(hd->u.h_lockspace), nodeid,
3428785a65dabf Alexander Aring 2022-04-04  4991  			  hd->h_cmd, type);
c36258b5925e6c David Teigland  2007-09-27  4992  
c36258b5925e6c David Teigland  2007-09-27  4993  		if (hd->h_cmd == DLM_RCOM && type == DLM_RCOM_STATUS)
bde0f4dba584ae Alexander Aring 2024-08-19  4994  			dlm_send_ls_not_ready(dn, nodeid, &p->rcom);
c36258b5925e6c David Teigland  2007-09-27  4995  		return;
c36258b5925e6c David Teigland  2007-09-27  4996  	}
c36258b5925e6c David Teigland  2007-09-27  4997  
c36258b5925e6c David Teigland  2007-09-27  4998  	/* this rwsem allows dlm_ls_stop() to wait for all dlm_recv threads to
c36258b5925e6c David Teigland  2007-09-27  4999  	   be inactive (in this ls) before transitioning to recovery mode */
c36258b5925e6c David Teigland  2007-09-27  5000  
578acf9a87a875 Alexander Aring 2024-04-02  5001  	read_lock_bh(&ls->ls_recv_active);
c36258b5925e6c David Teigland  2007-09-27  5002  	if (hd->h_cmd == DLM_MSG)
eef7d739c218cb Al Viro         2008-01-25  5003  		dlm_receive_message(ls, &p->message, nodeid);
f45307d395da7a Alexander Aring 2022-08-15  5004  	else if (hd->h_cmd == DLM_RCOM)
eef7d739c218cb Al Viro         2008-01-25  5005  		dlm_receive_rcom(ls, &p->rcom, nodeid);
f45307d395da7a Alexander Aring 2022-08-15  5006  	else
f45307d395da7a Alexander Aring 2022-08-15  5007  		log_error(ls, "invalid h_cmd %d from %d lockspace %x",
f45307d395da7a Alexander Aring 2022-08-15  5008  			  hd->h_cmd, nodeid, le32_to_cpu(hd->u.h_lockspace));
578acf9a87a875 Alexander Aring 2024-04-02  5009  	read_unlock_bh(&ls->ls_recv_active);
c36258b5925e6c David Teigland  2007-09-27  5010  
c36258b5925e6c David Teigland  2007-09-27  5011  	dlm_put_lockspace(ls);
c36258b5925e6c David Teigland  2007-09-27  5012  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

