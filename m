Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104E121B91D
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 05:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763358464; cv=none; b=DyXtkeEZgmybO9It1ZX/84XA6DMZFy3dEKjnUZ5tMPkl0y7iSFE1M4nB/liGWYADnSotlfwFQjTmhEHVY10Hjj2y5LLkAegZj9xlc+ZCRjLPhXW6vH+km639T5FVzV1i41WGWUTh0w8hLbfPrRWtHBwLZ4SZxU1OVbi1S0x36ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763358464; c=relaxed/simple;
	bh=lRuMMAQFfKtE9Hjz37VG/Ob85XUqc4TnBdjxVRw97ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owKvXNctincjHoWnPwAhKEQOvn7mq9uRRXLbNpWlFzxLEs23z1TwDF1+SwcxQahyrAVZHV17NL4BLUiYqvHQcPkGwn+5E8Dyuu3BPZzXiX5xbOizLHMHxEG0Wn4C8X5nvwoWmZporYiKMYV2zleU4ZB+owYvdAjCYDNI028bN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=ZiVrcGBf; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="ZiVrcGBf"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id KrLQv7Hq0v724Ks5PvUjsD; Mon, 17 Nov 2025 05:47:35 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Ks5Ov1hQ7XkiUKs5OvIOBt; Mon, 17 Nov 2025 05:47:34 +0000
X-Authority-Analysis: v=2.4 cv=MoBS63ae c=1 sm=1 tr=0 ts=691ab6f6
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=4DtsFWJC70/ZxGj2xnZlig==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=iox4zFpeAAAA:8 a=XhWbaVAy7xEXXl44f-sA:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=89x8whf2MOkQOTUoYg65n709kE93HhhjOZ/hCJbnnoE=; b=ZiVrcGBf7SX1mi8OH36yZsRghq
	uKQ/LBBp/ZzVs4rPcTWNX6Vp4HyWvehZQXJH+w0YiHxtXcJ+6mKZ/jK5K2AQD7XXSOnL/t9vqhjpX
	AydAFjXHuJeRAbwPBICWvu3q8sRzDAgc7PtC1a+JQIdqkfvG3IiaSlIgyVlVSEu7MJC+t4mqt5YoJ
	0tTgsvEfYf8WcZwh356Mbf3MP8kdUFIaSSNHVlXuoJOf+JejPZX1NN+RJpad+nEefKRwAgj24L+No
	kslT1ok3H+X7xOgyoS6/1FxYrs0KKx5ba70XrQbJ1lQE0tKPsGAGuw7yAWFLivfhAO5G6vzaKdy7z
	yiAzg9Gg==;
Received: from softbank126126126075.bbtec.net ([126.126.126.75]:36702 helo=[10.221.86.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vKs5N-000000003ZG-2b5r;
	Sun, 16 Nov 2025 23:47:33 -0600
Message-ID: <afd13315-7129-4f10-8e29-7832a00a4817@embeddedor.com>
Date: Mon, 17 Nov 2025 14:47:22 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] ocfs2: Avoid -Wflex-array-member-not-at-end warning
To: Heming Zhao <heming.zhao@suse.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <aRKm_7aN7Smc3J5L@kspp>
 <7vsq3tvjuv3ppiot3lgithyp76r4jbbssoiiuni6zvj5pajsov@nketwax66jss>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <7vsq3tvjuv3ppiot3lgithyp76r4jbbssoiiuni6zvj5pajsov@nketwax66jss>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 126.126.126.75
X-Source-L: No
X-Exim-ID: 1vKs5N-000000003ZG-2b5r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: softbank126126126075.bbtec.net ([10.221.86.44]) [126.126.126.75]:36702
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfChc65O+/j0z77Vp1zdeTBd4i/CfGJMqBpNhjOT6WsSVR4TYWc/bJKkA/EySqJ4tQ9qjKPWgd5G2AXCILz++yR8j+AAzicTpBepm8yKljoy99uEF9WZ3
 x8QLAiMJSjrcf1KyvL0UAQVlYO9qV1FizEalCIIX/1fIi44Z/pNkwSykqZVI7I4dGtR3O1s1NEg+/2ZRb1Xm3DNZ42pvpgmtJIu74TwRT5GlXnzxWSEverXm



On 11/17/25 14:32, Heming Zhao wrote:
> On Tue, Nov 11, 2025 at 12:01:19PM +0900, Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Use the new TRAILING_OVERLAP() helper to fix the following warning:
>>
>> fs/ocfs2/xattr.c:52:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
>>
>> This helper creates a union between a flexible-array member (FAM) and a
>> set of MEMBERS that would otherwise follow it.
>>
>> This overlays the trailing MEMBER struct ocfs2_extent_rec er; onto the
>> FAM struct ocfs2_xattr_value_root::xr_list.l_recs[], while keeping the
>> FAM and the start of MEMBER aligned.
>>
>> The static_assert() ensures this alignment remains, and it's
>> intentionally placed inmediately after the related structure --no
>> blank line in between.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Thanks, Heming.

-Gustavo


