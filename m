Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA256187352
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Oct 2024 02:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083885; cv=none; b=alLPmkH028lXnb3Ml6U8gXG9hPv2lQYboHwaNA5Svnl++0mv61dpnZtLxQhqsrj5TWjTSK7wLXMhSmgqwUfyH+aQq5eLwI4AsHCQ40fJGWNVzyJfRG4KoOzgq6unJBA3990h7JFxb5Vd4GfzrFOq4k9dCrtPtOtRT0/4SK7B19g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083885; c=relaxed/simple;
	bh=F48UsdI2f5ymQkitEb5YeCEmoQeb/N6jeR3g6jr5IU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hV+kxsINiIQAi44xa0eed8RCGUGLfg8TuYOCf3aZimksNxzowZaJDOBbvrLX3b3koNRV339ZkGE5udbeNZ/EcBBkP1oPFQSeLLqxbm2Vz8g9Zf/iyH8UdH6J/S0BMxzeAOnpLrBJiyOSRbNx2rAKpC0xIbJb+7oWnwFMr8JixjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=o1G6LZVw; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="o1G6LZVw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730083874; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aCLyB7UwexecECy6Kf81qfF6T6jufmyIj6/CNwQpU00=;
	b=o1G6LZVwj0elrkvGf4NsG5W6JXas8pvj+QuHyT4tHIii4QAa2u2lSCgISGogKh/FP/UXj3H10tzVqhPI9sPRi6wmdhgLjvD8CTsq6+tdwzrNK+MA8volpKLIvyTpUe+t8sYlOy75OTrUeaDteZHrBAZ8gFHsVQlHfVwWZpDjQso=
Received: from 30.221.129.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHzFVuI_1730083872 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Oct 2024 10:51:13 +0800
Message-ID: <7aa37ed6-d717-4340-8c27-60fd130496c1@linux.alibaba.com>
Date: Mon, 28 Oct 2024 10:51:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Remove unused errmsg function and table
To: linux@treblig.org, mark@fasheh.com, jlbec@evilplan.org,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241022002543.302606-1-linux@treblig.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241022002543.302606-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/24 8:25 AM, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> dlm_errmsg() has been unused since 2010's
> commit 0016eedc4185 ("ocfs2_dlmfs: Use the stackglue.")
> 
> Remove dlm_errmsg() and the message table it indexes.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlm/dlmapi.h   |  2 --
>  fs/ocfs2/dlm/dlmdebug.c | 53 -----------------------------------------
>  2 files changed, 55 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
> index bae60ca2672a..847a52dcbe7d 100644
> --- a/fs/ocfs2/dlm/dlmapi.h
> +++ b/fs/ocfs2/dlm/dlmapi.h
> @@ -62,8 +62,6 @@ enum dlm_status {
>  	DLM_MAXSTATS,             /* 41: upper limit for return code validation */
>  };
>  
> -/* for pretty-printing dlm_status error messages */
> -const char *dlm_errmsg(enum dlm_status err);
>  /* for pretty-printing dlm_status error names */
>  const char *dlm_errname(enum dlm_status err);
>  
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index be5e9ed7da8d..e9ef4e2b0e75 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -164,59 +164,6 @@ static const char *dlm_errnames[] = {
>  	[DLM_MAXSTATS] =		"DLM_MAXSTATS",
>  };
>  
> -static const char *dlm_errmsgs[] = {
> -	[DLM_NORMAL] = 			"request in progress",
> -	[DLM_GRANTED] = 		"request granted",
> -	[DLM_DENIED] = 			"request denied",
> -	[DLM_DENIED_NOLOCKS] = 		"request denied, out of system resources",
> -	[DLM_WORKING] = 		"async request in progress",
> -	[DLM_BLOCKED] = 		"lock request blocked",
> -	[DLM_BLOCKED_ORPHAN] = 		"lock request blocked by a orphan lock",
> -	[DLM_DENIED_GRACE_PERIOD] = 	"topological change in progress",
> -	[DLM_SYSERR] = 			"system error",
> -	[DLM_NOSUPPORT] = 		"unsupported",
> -	[DLM_CANCELGRANT] = 		"can't cancel convert: already granted",
> -	[DLM_IVLOCKID] = 		"bad lockid",
> -	[DLM_SYNC] = 			"synchronous request granted",
> -	[DLM_BADTYPE] = 		"bad resource type",
> -	[DLM_BADRESOURCE] = 		"bad resource handle",
> -	[DLM_MAXHANDLES] = 		"no more resource handles",
> -	[DLM_NOCLINFO] = 		"can't contact cluster manager",
> -	[DLM_NOLOCKMGR] = 		"can't contact lock manager",
> -	[DLM_NOPURGED] = 		"can't contact purge daemon",
> -	[DLM_BADARGS] = 		"bad api args",
> -	[DLM_VOID] = 			"no status",
> -	[DLM_NOTQUEUED] = 		"NOQUEUE was specified and request failed",
> -	[DLM_IVBUFLEN] = 		"invalid resource name length",
> -	[DLM_CVTUNGRANT] = 		"attempted to convert ungranted lock",
> -	[DLM_BADPARAM] = 		"invalid lock mode specified",
> -	[DLM_VALNOTVALID] = 		"value block has been invalidated",
> -	[DLM_REJECTED] = 		"request rejected, unrecognized client",
> -	[DLM_ABORT] = 			"blocked lock request cancelled",
> -	[DLM_CANCEL] = 			"conversion request cancelled",
> -	[DLM_IVRESHANDLE] = 		"invalid resource handle",
> -	[DLM_DEADLOCK] = 		"deadlock recovery refused this request",
> -	[DLM_DENIED_NOASTS] = 		"failed to allocate AST",
> -	[DLM_FORWARD] = 		"request must wait for primary's response",
> -	[DLM_TIMEOUT] = 		"timeout value for lock has expired",
> -	[DLM_IVGROUPID] = 		"invalid group specification",
> -	[DLM_VERS_CONFLICT] = 		"version conflicts prevent request handling",
> -	[DLM_BAD_DEVICE_PATH] = 	"Locks device does not exist or path wrong",
> -	[DLM_NO_DEVICE_PERMISSION] = 	"Client has insufficient perms for device",
> -	[DLM_NO_CONTROL_DEVICE] = 	"Cannot set options on opened device ",
> -	[DLM_RECOVERING] = 		"lock resource being recovered",
> -	[DLM_MIGRATING] = 		"lock resource being migrated",
> -	[DLM_MAXSTATS] = 		"invalid error number",
> -};
> -
> -const char *dlm_errmsg(enum dlm_status err)
> -{
> -	if (err >= DLM_MAXSTATS || err < 0)
> -		return dlm_errmsgs[DLM_MAXSTATS];
> -	return dlm_errmsgs[err];
> -}
> -EXPORT_SYMBOL_GPL(dlm_errmsg);
> -
>  const char *dlm_errname(enum dlm_status err)
>  {
>  	if (err >= DLM_MAXSTATS || err < 0)

