Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3DD2594BD
	for <ocfs2-devel@lists.linux.dev>; Sun,  7 Dec 2025 09:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765101052; cv=none; b=GRYBvwE13f3v0mM0dQJsuQ2/G3q0l/mN11BsWjPA993MZF/EEFwBVJSmL00dk0qoJ4Ie4gy+BIhQU4WZbUrpC8krfyFKvhfHrmNILobPwDhaZFZA6vfxqgKG6P5Xi2WEhSvD1rY+i92q0jFeUzmmDlefgGDvebngrCRVxa9vtbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765101052; c=relaxed/simple;
	bh=DRY1zpmGU/hhRzxL4ovTTz0CIRMnpeL6lEK+z1M9waA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRWEr/PJBe7AZe8Het8SeXQW73xZzaR22Vs0vg4G8JGC2hqHPaB1ftT9kIe2dIcReFe8pgFnffuHk1E5BhT3tkEW9jEKUzJC+dgLZ1gPTvwC5VafScUerFjrkJsjeOhdewwB9c2ehWc4vbCS9RDeSg2dxKbOfPO3uXZhM2vWcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T/ugpnEt; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T/ugpnEt"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4775dbde730so4444975e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 07 Dec 2025 01:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765101048; x=1765705848; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o6GF59OMxrJlmi+0MeK5ZFFlUaEsCtwZn20BYddiUPc=;
        b=T/ugpnEtxsU8FSLnvTwkwMlnXbiULhImTJOD51ZYsD8pMIQPxjFXCtBqyHlsLRQa/Q
         94Hyu3bO89NlI88/sTK2Gu8svxMNFlyxZfj1uYbre3E2Vii2DZRmphPvbLmOViHHpN/b
         VBeiqohL2ICvEK3Wl1JgwH9BFtD08+NDlbJKJbHtsAcSO5AKLhfoL8T3ezoGXB8lhliH
         VPUjC2hhwu8Mulr3tl2Q5Jo6SvDtPD+nJ0YTRJGukXj/Ku96p7r49+V3osVth8C9/R4U
         l9JYuHXu2N0oSTBc5CrRmA0vyCHyhUG165ghPaTYoR8VKnwOLneEO2TxgugWYtrVn0JN
         AqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765101048; x=1765705848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6GF59OMxrJlmi+0MeK5ZFFlUaEsCtwZn20BYddiUPc=;
        b=cuHVhEZbz5Ls+IKodZ380lhL7aixAQJzzsTToTMjBlSfFUSNL+kkeXYdPaFvjMAQNr
         11/n9T1fy5rM9pr8wIqqeccZYPXsJoMMQ+VlglpqlDgltapqOykTD2ajWWHgZ0yAMCBy
         N5VVFgNaWgW76TWWCbFwdwjxxRWcnfwF+NyB0X3opifrpsOyvBeQRoc1c9GBG2PD3ywf
         cxGueFka13hiV0PaeIBYnnVAMhVcNMaWiWv9F43yiXKoMUjw1LoHK6jA5uvwrmLpeVSS
         7nmhHq5G5MT2txhFw9GutGe5RUXQlDmdz78iZbFiZ5Y2Wu++T42sHO7p8UWAk/Ogu3WZ
         8p4w==
X-Forwarded-Encrypted: i=1; AJvYcCVqSA9WQUBvJJO0GNBVwLXk+IqShHOPzUNij/8+ypXl4OrOseGEEkt4sXkSAiTgcPfEFM/PNis9zp2Q+A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRTJLjSHPejjv1JOLlvKSsGlinwQxG/ntRZep/itgBgUdqod+f
	etR2IsR6E4FKfAw1L2oJMaeplc9EGGJi2MDAmS+IEOmH40UhdZLTOCV7QI+PZ4VU7uE=
X-Gm-Gg: ASbGncsl4nIGb6EcLD3Yx6hRDbLcDLhsWpjDw4X6qOWkLIEmKLrkftalg5ZX54rvKWZ
	dpr9xv3Kz+RLqQhcV9/mDmkw8/z4EBb08uPNRHvVwOrlcsu1A6rFb/3L5a/BEIn1GIb+ryrcxJE
	4ZlK/PW1dt8XWa2TUT5yD9aMKOk30rj1JYotHEHuXYL8J+K2C0FrFjQs2WrGnHocFLX3mnJ+qsy
	6lFiiwPBQPmv4FlxWBdweyYzbZMNP34DokYLdlhDTFvMG1XO74SfDqycjU2VPyFwZKl6LwbK0f4
	+08kCtSb6R0QZ/OWSFtcp2NIq+40s+sLh9PnxulvAmbreGGPFMZqZJj3SrOi1oTNNzFy/w4wHnU
	Q7dlO37/54zx/R9dZkS6gMkTYAGVYn6o++8G05L6zlXwmCDmKerEDyBovKxzWAHAM9S9x6Xyv2F
	jUYSqDR4Gjcg==
X-Google-Smtp-Source: AGHT+IEVr3OPbP9GMYiGhgvcJADSfM8F0pn2aKU1SIFK3qXZQgt5wfKIL51vd7m4DeDadm10PtfZ2w==
X-Received: by 2002:a05:600c:3143:b0:477:7b16:5f97 with SMTP id 5b1f17b1804b1-47939c8b36bmr33098585e9.0.1765101048403;
        Sun, 07 Dec 2025 01:50:48 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6817395ccsm9064913a12.5.2025.12.07.01.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 01:50:47 -0800 (PST)
Date: Sun, 7 Dec 2025 17:50:45 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH RESEND v4 0/2] ocfs2: give ocfs2 the ability to reclaim
 suballocator free bg
Message-ID: <rn5criadn3vvtoucxnfalw5utfdjpge2rh6qtjjazr445hqm2l@rppqbguol4mk>
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <973ba880-01b2-4d1c-992d-01140e24beb4@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <973ba880-01b2-4d1c-992d-01140e24beb4@linux.alibaba.com>

On Fri, Dec 05, 2025 at 05:22:47PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/2 14:39, Heming Zhao wrote:
> > why resend?
> > - the v4 summary description in the cover letter is incorrect.
> > 
> > v4:
> > 
> > Most of the changes involve revising comments. For the code itself, there are
> > function renames and parameter usage adjustments, but no changes to the code
> > logic.
> > 
> > For patch [1/2]:
> > - Based on Joseph's v3 review comments:
> >   1. Modify the caller to initialize the ocfs2_read_hint_group_descriptor()
> >      input parameter '*released'.
> >   2. Rename the _reclaim_to_main_bm() to _ocfs2_reclaim_suballoc_to_main()
> >   3. Change the text "not empty rec" to "non empty rec"
> > 
> > - Revise the comments preceding the function _ocfs2_reclaim_suballoc_to_main().
> > 
> > - For the question: "How to distinguish the release case or a bug?"
> >   I write a comment before ocfs2_read_hint_group_descriptor().
> > 
> > - Revise the commit log to make it clearer.
> > 
> > For patch [2/2]:
> > - Revise the commit log to make it clearer.
> > 
> > Remove the v3 patch: "ocfs2: adjust spinlock_t ip_lock protection scope"
> > - Reason: This patch belongs to a different topic/job and should be
> >           handled separately.
> > 
> > v3:
> > 
> > For patch [1/3]:
> > - Factor out the reclaim code into a new function '_reclaim_to_main_bm'.
> > - The function ocfs2_read_hint_group_descriptor doesn't return -EIDRM
> >   when the group descriptor is invalid. The new code logic returns 0,
> >   and the input parameter '*released' is set to 1.
> > 
> > For patch [2/3]:
> > - Modify the code to follow the new logic of ocfs2_read_hint_group_descriptor
> >   as introduced in patch [1/3].
> > 
> > For patch [3/3]:
> > - No new changes.
> > 
> > v3 patch has passed the xfstests:
> > ./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
> > -e generic/081 -e generic/266 -e generic/272 -e generic/281 \
> > -e generic/331 -e generic/338 -e generic/347 -e generic/361 \
> > -e generic/479 -e generic/480 -e generic/628 -e generic/629 \
> > -e generic/648 -e generic/650
> > 
> 
> Hi, could you please send out the ocfs2-test results as well?
> 
> Thanks,
> Joseph

I have run the xfstest with above style:
./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
-e generic/081 -e generic/266 -e generic/272 -e generic/281 \
-e generic/331 -e generic/338 -e generic/347 -e generic/361 \
-e generic/479 -e generic/480 -e generic/628 -e generic/629 \
-e generic/648 -e generic/650

with/without the patch set, *Failures* are same:
generic/003 generic/007 generic/228 generic/322 generic/329 generic/376
generic/383 generic/384 generic/385 generic/386 generic/420 generic/424
generic/448 generic/449 generic/510 generic/513 generic/537 generic/552
generic/563 generic/578 generic/594 generic/607 generic/620 generic/630
generic/741 generic/755

For the ocfs2-test, it seems that open-mpi4 does not work correctly in my test
environment (OpenSUSE TumbleWeed). Therefore, I only ran the tests in single-node
mode. The results were the same between the patched code and the unpatched code.

ocfs2-test cases:

$ single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l \
/usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk \
-n hacluster -t create_and_open,directaio,fillverifyholes,renamewriterace,\
aiostress,filesizelimits,mmaptruncate,buildkernel,splice,sendfile,reserve_space,\
mmap,inline,xattr,reflink,mkfs,tunefs,backup_super

$ discontig_runner.sh -f 1 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster /mnt/ocfs2

- Heming
> 
> > v2:
> > 
> > Create 2 new patches:
> > - ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
> > - ocfs2: adjust spinlock_t ip_lock protection scope
> > 
> > In ocfs2_read_hint_group_descriptor()
> > - bypass the validation of GD when the BH is already managed by jbd2.
> > 
> > In _ocfs2_free_suballoc_bits()
> > - Move up the position of the vars 'idx' & 'rec'.
> > - Move up the position of the ocfs2_journal_dirty.
> > - Use le[16|32]_to_cpu() to access cl/fe/rec vars.
> > - Add error handling for calling ocfs2_extend_trans().
> > - adjust spin_lock ->ip_lock protection scope.
> > - Follow Glass's review comments, add 'comment' & 'else-break' for the
> >   'for-loop'.
> > 
> > v1:
> > 
> > Only create patch:
> > - ocfs2: give ocfs2 the ability to reclaim suballoc free bg
> > 
> > Heming Zhao (2):
> >   ocfs2: give ocfs2 the ability to reclaim suballoc free bg
> >   ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
> > 
> >  fs/ocfs2/suballoc.c | 336 +++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 317 insertions(+), 19 deletions(-)
> > 
> 
