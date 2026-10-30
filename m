Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342305;
	b=uipumZNmhLfaVo12lRU7RMRjLlI0katR9hu3lnbNMcqJ19POzZYW3/f4fcagHnMnnjBL
	 1SXz/Rrfou7ojHfbpKddi+txSCvOHH0z+OrZkKrw1qAFjZ5LVGeTzAEJ8nFqt3sq9vG7s
	 OoFZTKD/mrUy1zhfGkevBnTT2wkaYpQLDYaI8s55mAFw7Ny8r3iPdQ9P6/C9LBCIrcQO2
	 lahniGCrvDn0q1/nsiAMiQPNLOTP57Z7U/ejiGbQryW6jhgNOSlTkRN5nib7qpOn8THz6
	 DX7PKLmmpDytNuluyinXp3Nc5kpUUPCbdzCBNOFUIYVa4m3M8pOnVQNn9kpcxAsqH6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342305;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=c9bH+QvZJ7eE+0TyX52Q+M/KU2BPVS2HPYviFeixx+c=;
	b=uZtUPsejH1NzUrxiLtmgTQivl6vAzmGikwgXqNswbkR/9G2dKtT/UbdSMmoikQuJqhx9
	 gLcy+4i4Fbg3BqaTQnAu/PbiLKzGYwY/OvX4VnJxpY6G5gWh+FUNfbuT1KzOJQYjoW8es
	 Bn3aJEUhpvlyXuKiTl+y4tVvBSDWjjMYa1AhAcRHepsLXpTRiUweDe6uAQvvDOGyENneG
	 TOW5rXpjnZvUb0pDfk0VIPx/lQc6im5AaVR+81njwlgpU97Xf5uTMx0YarF0k2f5ejsIR
	 eQvWzpTl9QYTJOeQ68BsTjStYGtNObM8A+0esXtLuXRodW3avSxhb093zQxqfz2YEuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCOFAEZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB6606A31A;
	Fri, 30 Oct 2026 06:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCOFAEZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C461F000C1;
	Fri, 30 Oct 2026 06:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793342305;
	bh=c9bH+QvZJ7eE+0TyX52Q+M/KU2BPVS2HPYviFeixx+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fCOFAEZzDyCuuyvuQWET/wbjiJepYciWmK7ue53SUFlvPH5p4ge1dbwPPXyyJ80Tu
	 s7PbvkTlzA+yKqcdKq+kON04IRCbQaNGvKAPBa/WpWMfrM5HAuototBriuSwu+QMjf
	 csuwnHMnkZMk9m/lqkDUdlMpxnJ5I1GJ9+nvOwpY=
Date: Thu, 29 Oct 2026 23:38:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Cen Zhang <zzzccc427@gmail.com>, mark@fasheh.com, jlbec@evilplan.org,
 heming.zhao@suse.com, kees@kernel.org, kuba@kernel.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Subject: Re: [PATCH v2] ocfs2/cluster: unlink socket containers before
 releasing resources
Message-Id: <20261029233824.ff69052e942cc24f4166c22e@linux-foundation.org>
In-Reply-To: <ff8d866d-f318-4722-a1ab-88db7a3fde63@linux.alibaba.com>
References: <pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com>
	<ff8d866d-f318-4722-a1ab-88db7a3fde63@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Oct 2026 10:17:57 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> 
> 
> On 10/13/26 11:34 PM, Cen Zhang wrote:
> > A socket container's node and socket must remain alive while the
> > container is on sock_containers. The debugfs formatter reads sc_node
> > and sc_sock under o2net_debug_lock without taking their references, but
> > sc_kref_release() releases both before taking that lock to unlink the
> > container.
> > 
> > With CONFIG_DEBUG_FS enabled, a synchronous sender can retain its last
> > socket-container reference after o2net_disconnect_node() has detached
> > the connection and flushed o2net_wq. The caller runs outside that
> > workqueue. After the sender removes its configfs dependency, node
> > removal can proceed without waiting for the sender's final sc_put():
> > 
> >   Sender (final sc_put)    Configfs rmdir        Debugfs reader
> >   --------------------    --------------        --------------
> >   o2nm_undepend_item()
> >                           Drop node item refs
> >   o2nm_node_put()
> >     [node can be freed]
> >                                                sc_seq_show()
> >                                                  Lock debug lock
> >                                                  Read sc_node->nd_name
> >                                                  Unlock debug lock
> >   sc_node = NULL
> >   o2net_debug_del_sc()
> > 
> > The earlier socket release has a similar window. The container is
> > still selectable while its socket has been released and sc_sock has
> > not yet been cleared:
> > 
> >   Sender (final sc_put)                       Debugfs reader
> >   --------------------                       --------------
> >   sock_release(sc->sc_sock)
> >     [socket can be freed]
> >                                              sc_seq_show()
> >                                                Lock debug lock
> >                                                Read sc_sock->sk fields
> >                                                Unlock debug lock
> >   sc_sock = NULL
> >   ...
> >   o2net_debug_del_sc()
> > 
> > Move o2net_debug_del_sc() before releasing either resource. Unlinking
> > under the existing debug lock waits for an active formatter to finish
> > and prevents later readers from selecting the container. This covers
> > both socket fields and node fields, including nd_num in the stats
> > formatter. Release the debug lock before the existing resource cleanup.
> 
> sc_kref_release() never holds o2net_debug_lock, the lock is taken and
> dropped inside the helper o2net_debug_del_sc().
> 
> So better to:
> 
> s/ Release the debug lock before the existing resource cleanup.//

I made that edit, thanks.

