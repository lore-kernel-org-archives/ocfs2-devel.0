Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F224198A1B
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Sep 2024 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726395537; cv=none; b=ORCWsHboRSN3czD2VSh8TY11Qu5HJ689LFFEPFjaE+CKQpqycwklNs5prFD0EAqBgUg2F4/N2eqt8L7HLjvA43OeElIwvEYqfUhltwQ1UItWAqfWv5yLhSM8kBaUvHYki8uEfjgSfqiRfDSfFTho+R1362/25mLkpleLQ66IrP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726395537; c=relaxed/simple;
	bh=5asS+9IROfr+gx/EpfDa3DPhIlJPUyQA2tTO6kw9JvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=AivVSniioEpHOxnGT1SHVTyKYtPqM1eJKfwPNls6RFYcNS0wP25uki+jwXImFwORh/z1EmgtzLboXimZwXzvNK6zU+vfqY/GteO92pa+9aABAscyFDa+ZE8uTEEe7uiDGI4jcPfycJT+NyLnQCC8Gi69x2VqEpNSMMVyceDTmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvYPUjOh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvYPUjOh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726395533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tmbz14FTYLX02iYWpuHPfKuf/8mbf1kjNdoBR1mare0=;
	b=DvYPUjOhakxBiZp4Yt/WbdOKBZ3HAI7GLtDEqNGAEMdDwFJALQVkAzVsJlnsamKtXV5XPe
	Ot656TVzQl2NEmXW3CnadzaJPVAMM9DIpOnBbhShxqphxHD9znaWjFoVlUPaPitoTMTlP2
	f9W+91QlkvVkzW/zDAxBgzIHXOs9DBc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-hiwGN2VRMmC0iKC52xLbow-1; Sun, 15 Sep 2024 06:18:52 -0400
X-MC-Unique: hiwGN2VRMmC0iKC52xLbow-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-374c32158d0so2094721f8f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Sep 2024 03:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726395530; x=1727000330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tmbz14FTYLX02iYWpuHPfKuf/8mbf1kjNdoBR1mare0=;
        b=qcujLVRKqSIz5myVKEixcaAaDcsIilnNgBLS1yYY5+2YFb91D0PF6ByeiaasbpKOLi
         8jPkjI/KxaqLuguGnlPohokWXNAJK1aYaZoL2i55z2lr1ft8wKYfE4/tP/EcCD/kYJa8
         oZ/2+QSElIfiW/hsWz+fEAYEEmVWDoJwrjQ2WtLrvoM0GAM1u5AzsX/OhAc+jRYrRGVi
         OYVDmX7PfjIok6RPYj6NnTHDGBGMcgTqSX4U0TUuT5ybiwDrzV9bsD9MAtXFIGFGcqNn
         FE/s/xGDG/ESImlAuxHmcNIP+qMpeYiUTvQI+MXqKC2Lxb0Z8A18G9bh0z3WXVoavndI
         kaPg==
X-Forwarded-Encrypted: i=1; AJvYcCXfPYWbFFDrYQDJrjB2aA5aNDZ5btGajCqjTffJ6v7CcFL0sFhxtdTHLrnIdIx0qZH4VncE2HPC9BcNPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyrFcWK9c6xgYdMy8n+DoMXu5e8xqCffQbyCjr54+GyKyUd3DDl
	3AJq+wWb1cFFcyxyX5VrSIbycwsdL51cDTMk69Yhg+S+e2itm0nKJXeFDkfGQyHphXyDsSoRQNM
	xGy3bAAuGLg4ZHyP1Vv9pUNA9Ve1NsPnl/+FdOkD2PC5+EseitSHC6kDi93/P
X-Received: by 2002:a5d:42c7:0:b0:373:54c:26a4 with SMTP id ffacd0b85a97d-378c2d5782bmr6228065f8f.54.1726395530569;
        Sun, 15 Sep 2024 03:18:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGB48f7P6d5tWE1CN4fj3qaV7XamhtUAE7O9AfTIiv2AqG4TKhfjAP1n9uCEoD9oAMV8D21yA==
X-Received: by 2002:a5d:42c7:0:b0:373:54c:26a4 with SMTP id ffacd0b85a97d-378c2d5782bmr6228046f8f.54.1726395529478;
        Sun, 15 Sep 2024 03:18:49 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f7:64c8:bef6:26d5:abb8:992b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e73e81a5sm4332957f8f.34.2024.09.15.03.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 03:18:48 -0700 (PDT)
Date: Sun, 15 Sep 2024 06:18:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: syzbot <syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com>
Cc: elic@nvidia.com, jasowang@redhat.com, jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
	mark@fasheh.com, ocfs2-devel@lists.linux.dev,
	ocfs2-devel@oss.oracle.com, parav@nvidia.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ocfs2?] possible deadlock in
 ocfs2_reserve_local_alloc_bits
Message-ID: <20240915061811-mutt-send-email-mst@kernel.org>
References: <000000000000ac4a9d062044e498@google.com>
 <0000000000000c5506062224dd83@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0000000000000c5506062224dd83@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 15, 2024 at 02:13:02AM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit a3c06ae158dd6fa8336157c31d9234689d068d02
> Author: Parav Pandit <parav@nvidia.com>
> Date:   Tue Jan 5 10:32:03 2021 +0000
> 
>     vdpa_sim_net: Add support for user supported devices
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174bbc77980000
> start commit:   0babf683783d Merge tag 'pinctrl-v6.11-4' of git://git.kern..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14cbbc77980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10cbbc77980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c9e296880039df9
> dashboard link: https://syzkaller.appspot.com/bug?extid=843fa26882088a9ee7e3
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129a6407980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167617c7980000
> 
> Reported-by: syzbot+843fa26882088a9ee7e3@syzkaller.appspotmail.com
> Fixes: a3c06ae158dd ("vdpa_sim_net: Add support for user supported devices")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection


something very weird going on here.
don't see how this can thinkably cause a deadlock in ocfs.

