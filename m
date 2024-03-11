Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [116.203.65.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3D454BDB;
	Mon, 11 Mar 2024 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.65.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710185260; cv=none; b=lOtsCnh0A0zPghefr2IqEJ0cViMMRWuQZumKDrMucfBjc3SftllFqsSvfUPwo2duRFrU19F7YroWhPqYS9bFTwP0PjaBY/mZKNmfX4IQ8WVeUhheJ5D3g+Y0r3ynhNyRryfM1lmf20mYvmaEgZTrkJGhgfiJadH6hVJ4yG9Vx68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710185260; c=relaxed/simple;
	bh=ibxuGp1qvilA5Ju1yYwsz1Pnvs39WHKj3S+X22PljvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3jkkjYdiuleDYD6MgwyvYm2lZ4PsicvNqnYbuaANzKHO9/OHx9VHwdrR8ehFMnGFNh6ycBIHc6Xv0BqucLXn2CYSl6N4Bzh+YSnIhmnGtxjuj+etkcy8MSsfP5uGi5GEwkPTE+CI6GPrs4qt72A/U3lMze/aWzIispCXeMg708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr; spf=pass smtp.mailfrom=valentin-vidic.from.hr; dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b=0JhycYEX; arc=none smtp.client-ip=116.203.65.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valentin-vidic.from.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=valentin-vidic.from.hr header.i=@valentin-vidic.from.hr header.b="0JhycYEX"
X-Virus-Scanned: Debian amavis at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=valentin-vidic.from.hr; s=2020; t=1710185250;
	bh=ibxuGp1qvilA5Ju1yYwsz1Pnvs39WHKj3S+X22PljvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0JhycYEXSTkKEcoMJjHU3vkP6sfoBK7RF7VV9PKkbqQ6QPLAJVmpJiZhEuMkNS3SV
	 ysayVesWmhk4VGgz1cVpMlfYIbt5uqdTYfXrdR38ydeay4Y/pwOwP3TckBY2ZgRVoc
	 RoQsvgx2NcA+GzBzQQ8eQZvWdICZlFxiK9ClhZAS02vhdOsorQObfymtfk7en2s2cy
	 QjTLI99jFaeQMKiKdrviiMNKQy/dWNYsi3B0Eew0RZc/KDWEHnUuoGg2FPrtaHLs0g
	 4tuoMVSnGL4/pvDaUOH/P4lSgo/kWEPl5MISN589K2qEACywmsShX9IZNEgqPfsL9r
	 QrebEH6myFUQMW9EfFmQW935KrxTmAlAALzSeiH2ZcTxnohUoPeOpjTmNxUEgiQxKF
	 ZhkYpRcWwnhpb9Mpde/GJxKSfWkshkodONbQz61mUnq6bNw5bEw9gCkUmWj1G6ZHEw
	 9mFL15PYbSAdw99LBz0JPv4xWHmtxF75aUVjB1vT5PPriI3uZVV4pjZaVnoaJOnBM7
	 5VBEThdekjczpC24gFoU6W29msaDRGYLANyjZMFVzyvANtMxUocyROLg8uJPwZfW0P
	 eXyHK4pAx/wcI25IRqRzZ1V4UGt9ZKITLZC/8FurKWXyPVRCZ5+Vq9dDERgLFj07Hj
	 NnUpuChP9QodwpGSn8e6H3yM=
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
	id 369B92D2A6; Mon, 11 Mar 2024 20:27:30 +0100 (CET)
Date: Mon, 11 Mar 2024 20:27:30 +0100
From: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To: Alexander Aring <aahringo@redhat.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev,
	ocfs2-devel@lists.linux.dev
Subject: Re: ocfs2 mount error
Message-ID: <Ze9bIiT3rAWTtPJp@valentin-vidic.from.hr>
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr>
 <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr>
 <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>

On Mon, Mar 11, 2024 at 11:20:56AM -0400, Alexander Aring wrote:
> when I try doing your steps (btw: thanks for sharing) to run
> fsck.ocfs2 it tells me:
> 
> fsck.ocfs2: Unable to access cluster service while initializing the DLM
> 
> Looking into strace right before that I see a:
> 
> connect(4, {sa_family=AF_UNIX, sun_path=@"ocfs2_controld_sock"}, 22) =
> -1 ECONNREFUSED (Connection refused)
> 
> it's true I don't have ocfs2_controld running, after looking into
> ocfs2-tools source code, I declare it as not compilable with recent
> corosync versions.

Not sure about that, because I also don't have ocfs2_controld running.
This is ocfs2-tools v1.8.8 with corosync v3.1.7. Perhaps cluster stack
should be set with:

  echo pcmk > /sys/fs/ocfs2/cluster_stack

> btw: a "trace-cmd stream -e dlm" would be nice to debug this issue.
> After I look at your debugging information it would be nice to see if
> the device() read for ast callbacks are there.

Here is a trace report for the fsck call:

cpus=1
      fsck.ocfs2-1696  [000]    54.621075: dlm_lock_start:       ls_id=2352585329 lkb_id=1 mode=PR flags=VALBLK res_name=2e39323539656662313866316162386331
      fsck.ocfs2-1696  [000]    54.692487: dlm_lock_end:         ls_id=2352585329 lkb_id=1 mode=PR flags=VALBLK error=0 res_name=2e39323539656662313866316162386331
      fsck.ocfs2-1696  [000]    54.695447: dlm_ast:              ls_id=2352585329 lkb_id=1 sb_flags= sb_status=0 res_name=2e39323539656662313866316162386331
      fsck.ocfs2-1696  [000]    54.695636: dlm_lock_start:       ls_id=2352585329 lkb_id=2 mode=EX flags=NOQUEUE|VALBLK res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    54.766959: dlm_lock_end:         ls_id=2352585329 lkb_id=2 mode=EX flags=NOQUEUE|VALBLK error=0 res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    54.770765: dlm_ast:              ls_id=2352585329 lkb_id=2 sb_flags= sb_status=0 res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    54.770821: dlm_lock_start:       ls_id=2352585329 lkb_id=3 mode=EX flags=NOQUEUE|VALBLK res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.845613: dlm_lock_end:         ls_id=2352585329 lkb_id=3 mode=EX flags=NOQUEUE|VALBLK error=0 res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.848395: dlm_ast:              ls_id=2352585329 lkb_id=3 sb_flags= sb_status=0 res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.868951: dlm_unlock_start:     ls_id=2352585329 lkb_id=3 flags=VALBLK res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.958319: dlm_unlock_end:       ls_id=2352585329 lkb_id=3 flags=VALBLK error=0 res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.982397: dlm_ast:              ls_id=2352585329 lkb_id=3 sb_flags= sb_status=-65538 res_name=4d303030303030303030303030303030303030303031383937333737316531
      fsck.ocfs2-1696  [000]    54.982450: dlm_lock_start:       ls_id=2352585329 lkb_id=4 mode=EX flags=NOQUEUE|VALBLK res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.056390: dlm_lock_end:         ls_id=2352585329 lkb_id=4 mode=EX flags=NOQUEUE|VALBLK error=0 res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.058946: dlm_ast:              ls_id=2352585329 lkb_id=4 sb_flags= sb_status=0 res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.082546: dlm_unlock_start:     ls_id=2352585329 lkb_id=4 flags=VALBLK res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.182903: dlm_unlock_end:       ls_id=2352585329 lkb_id=4 flags=VALBLK error=0 res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.210128: dlm_ast:              ls_id=2352585329 lkb_id=4 sb_flags= sb_status=-65538 res_name=4d303030303030303030303030303030303030303031393937333737316531
      fsck.ocfs2-1696  [000]    55.530687: dlm_unlock_start:     ls_id=2352585329 lkb_id=2 flags=VALBLK res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    55.625015: dlm_unlock_end:       ls_id=2352585329 lkb_id=2 flags=VALBLK error=0 res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    55.650054: dlm_ast:              ls_id=2352585329 lkb_id=2 sb_flags= sb_status=-65538 res_name=53303030303030303030303030303030303030303030323030303030303030
      fsck.ocfs2-1696  [000]    55.672033: dlm_unlock_start:     ls_id=2352585329 lkb_id=1 flags=VALBLK res_name=2e39323539656662313866316162386331
      fsck.ocfs2-1696  [000]    55.766844: dlm_unlock_end:       ls_id=2352585329 lkb_id=1 flags=VALBLK error=0 res_name=2e39323539656662313866316162386331
      fsck.ocfs2-1696  [000]    55.791829: dlm_ast:              ls_id=2352585329 lkb_id=1 sb_flags= sb_status=-65538 res_name=2e39323539656662313866316162386331

-- 
Valentin
