Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9157865;
	Tue, 16 Jan 2024 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435771; cv=none; b=tJlLFmCateCLINVWbUIGiD4bAaO2gmgtFJjJ2tAlfkfHFEMnN8VICbPsAXURGp2ZsyhFNBSL3DgrN875ySMjnujuJ/eKvU80vdb+MWzd3OJIf6nUHg2uNk9TQ4e8ZCRRtptFI3Ww2IYFbO6zgPwAiUy0mV/cpTPQq+ZvmIbPX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435771; c=relaxed/simple;
	bh=/J1wD6JlqLab/M4j5vio3L4cnTN/46KpjHXXEocQ4g0=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding; b=ruzYEXqHL6fyrA/OwNz+5ArliAgm4ewhrjr5DLAjqD5BqetyYtyfbOGFHRZD//BnIH4MCKv1TywUlnvQfdYidhiFtjwsPoDjnsdJr9oYJ0dYEmqcbTqKjB1/zeBa2sOcENE5b2KsVZk6vsaOBbRnLiO18/0lVoG3eifR1loiRqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GqnClk3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GqnClk3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C20C433F1;
	Tue, 16 Jan 2024 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435770;
	bh=/J1wD6JlqLab/M4j5vio3L4cnTN/46KpjHXXEocQ4g0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GqnClk3Sj/JtMpW5BMJL3Zwe9zJCWTweck+WljmNgOp4d94a05NBJu7py0xG1O+f6
	 YOyVN3c5DVhVzMVcDAR3CR7N+IkoaCNUpBQfE8NZ7Faes4sms5DlhFZ5GI4Al7mrdW
	 jYv6kJh0Z8XYHvnuRPupo9RHKwAv5J/N4P6BXysU=
Date: Tue, 16 Jan 2024 12:09:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Su Hui <suhui@nfschina.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
 justinstitt@google.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ocfs2: remove useless code in ocfs2_try_to_merge_extent
Message-Id: <20240116120926.3bfa87253bf5af5090bd78bd@linux-foundation.org>
In-Reply-To: <20240112042639.3948236-1-suhui@nfschina.com>
References: <20240112042639.3948236-1-suhui@nfschina.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 12:26:40 +0800 Su Hui <suhui@nfschina.com> wrote:

> Clang static checker warning: Value stored to 'rec' is never read.
> Remove this useless code to silent this warning.
> 
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -3743,8 +3743,6 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
>  			goto out;
>  		}
>  
> -		rec = &el->l_recs[split_index];
> -
>  		/*
>  		 * Note that we don't pass split_rec here on purpose -
>  		 * we've merged it into the rec already.

Then:

		ret = ocfs2_merge_rec_left(path, handle, et, rec,
					   dealloc, split_index);

and ocfs2_merge_rec_left() almost immediately dereferences `rec'.

So this looks quite wrong to me.
