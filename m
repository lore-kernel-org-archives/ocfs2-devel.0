Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621ACA47
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735872502; cv=none; b=muNZTIVYt9QVMelTjOpusKf3vdJXQ/Jrjz7FqJgyxqiTr7poSE48I1SrBjnyQXTtdl9yARcivxIRLiBg2yZ4NyLy6lAT1YIntlWwuOyQ1lNNf4gy22Vf7IPehKBoV7OSaXg586h2Alm0p6WxmLbXfhTNssTnC0Yc3JHBjNPjYnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735872502; c=relaxed/simple;
	bh=P4yG0LgSquMFD8C58KTt6lKrNxXw/SvqHjKdJ2qZB8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqSD1shJrfILzO6JJSM7aHcG4ZVXmbbHJVXk1pAfRz/8ECcp84eWB04f69udsmsSoAnkgXHQuK4EztwJpndJoC/K55ZyUEIZbW33tmEXFnMxYhfX+j3uZz//mZPp1u1PRp8kJbJqmja2wuSf/7eMe9BmCozb/lXUSYtmdc5QrHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dPed2SV0; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dPed2SV0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735872491; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o8ztY9q0jAJsSQMVMUBt0ExRClKMIYDGanb9IqHWJYI=;
	b=dPed2SV0ogU42+qvSsKMrOXFsjb4tT1z94uOY0grYHt9B/2ymqvqE6hHaGtFHtQWW5BU3j8naAmmt4Zzt7O+03Tp4vit/CWgZRYHz0gIPSV8ATqLbG3ywlJis8lpU6chYKaXUnCYbNMTgOVe+Vvd55LHP40CJ8ttXxaqETWdbDc=
Received: from 30.221.128.253(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMrhw1i_1735872489 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jan 2025 10:48:10 +0800
Message-ID: <73897870-03c6-4a81-a311-b6e1a75957f4@linux.alibaba.com>
Date: Fri, 3 Jan 2025 10:48:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ocfs2: Add a sanity check for corrupted file system.
To: Glass Su <glass.su@suse.com>, Julian Sun <sunjunchao2870@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
References: <20250102124539.711325-1-sunjunchao2870@gmail.com>
 <B8A96D29-146B-403F-8AFC-4098488599EC@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <B8A96D29-146B-403F-8AFC-4098488599EC@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/1/3 10:15, Glass Su wrote:
> The subject is too generic. Would you please change it to something like:
> 
> "ocfs2: check ocfs2_extent_list::l_next_free_rec in ocfs2_get_clusters_nocache”?
> 

Or simplify to
ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
