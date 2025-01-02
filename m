Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7723FE4
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Jan 2025 12:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735820395; cv=none; b=QXzM4atqHzRUsllkoAoLxHu/pgK/nOZ/9HDIVg3vtigxTm9Vge/HnIwN7kghjcbAaUhsG8cknHFuI96hk5b3cgEzUTnFG8uHkY6wi1iV0rYykTZgy/8VjxgEjUCbSuSZ+N5S5ArXZ9stfk/pTwiANXKueNYwwdayj+P9TykwnIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735820395; c=relaxed/simple;
	bh=XnaTe+3MJzcDDbWtO9gou5e9CkFbTeScpPhAkXUdZ7g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DNKc3okSp6aTaqHzUqh1S7nFqf7+GHeexg33y0rtcgdLOuobCaMteNYOaovPbzrKGtm5I0Zx81wPplpCweMIaph7iLJVWjI6T7lIEyz+3r2qu+7cwaIU5+jfGQgBKOKH1uez9D9jWfclI5VYNfU0isceRiKfbzZrN71rY2Og4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEGGz2Te; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEGGz2Te"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6dd16e1cfa1so98039166d6.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 04:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735820392; x=1736425192; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XnaTe+3MJzcDDbWtO9gou5e9CkFbTeScpPhAkXUdZ7g=;
        b=QEGGz2TeHk1qKdvTcMa0LQjlF3+dVLjrvu2cQXrscCYuD8agLl4aLdIloX6vUztsr1
         49PTyWAm/qjSfmGGF1bGffuPUsKDGPNb0nKzchZEbP4qM6Pe+fsKBlnkpwf3aLRVWa8g
         R4QFPrG43kdpWBZt1LajUJ1AStLXaiNwHZpaW2Ap0F1h14GD5WWveLRa6QH38fassjzu
         zkrmOn15CI20Bd4yfos+2hyxz3OuDf+Ris1mFSCrSae8FGVkcyOF3sKi0kjKHwDlTdGN
         YsC7VHMQJYVHNF58OLV1vPGcxt3GCgURxdDSI8cvH5C0KOWAPXcdig7BlId40oP4n+5p
         4LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735820392; x=1736425192;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XnaTe+3MJzcDDbWtO9gou5e9CkFbTeScpPhAkXUdZ7g=;
        b=tOuzPdGVwTNs6Cu1mKlWrcvMoZ0P3iOi7brGeqM0yDEkTZb+F549yGcyYoV+Rl6eyj
         5T9OIuSPFQiwFmYFqAXxKZ9jDdwMpBhlcpcxD8Fk0CIjfccOVrB4UiDECBr4n49MpNX9
         KKCIlXhzLJ5vjYj2DfZhQMIojkIev1M+CNMaFXWkcyf7S33chMyQ1XxvfyT1PI1UGMGn
         yHbvUPOROwH8mnf0/EW0V/e5REKSQIgIdtV1tNHBTBKa76X7l0R+CmBudu6zwZlxavBd
         fJ7HKJXfRaNtdRkjhxqcScyevJofzN/fsmCmC97VtUhheNa5OPW5nz5iBOt9L7iXx/0+
         HwPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8H9+WMQs4Swv81pO1pkU1cc6M9lvTjlvfxo59V3eHsfkVzYZIEU9Y/mIaG7a4Drh893TDvfbA99LTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YySq8bXTNZEMuiUn95Hs5Uh9+wOthn3npeaGG8ltpl2X1yIegLm
	uZoCFtP+lmR+FRvVcp2JzKmcWrFHURI1wwVZK8ydfr35NEwlbl0I
X-Gm-Gg: ASbGncvdRtZXovYHcoudxq7W3bmVTScHUa+m8R30vKg6/ZUFV2QiHZclZsjLkJX2Th3
	0lkAojgoyb2CymajDkZumbrlGA9wWscPvKT1yUI6UGzuqhjwFNYT0QdA9dASH6gH26a5EvjPPrf
	abrg81iDpAN+JUICzYdQPiXDQirTCuDBXUGkF8QP10B7TfESxjV5RRpNA9sCEmMonmgZFE9sL0a
	eKNHZSdarMoo/JKo2NJus+iM6tzR6McIAmvyvNHzAwSXPs6qD5KbJtQ1aD/K/z6koXOWTIkeoPv
	vp2rVmzwI+oZBMxs+4C7
X-Google-Smtp-Source: AGHT+IFcI0l0jy/kc2VJXtflAi3Vdr6pwtp0BDnZZuBNt8U0+QQJHIGmLdPGMb0U1J1GLj59qsNY9A==
X-Received: by 2002:a05:6214:21e3:b0:6d8:9abb:3c28 with SMTP id 6a1803df08f44-6dd23367719mr765964206d6.29.1735820392227;
        Thu, 02 Jan 2025 04:19:52 -0800 (PST)
Received: from [10.172.23.41] ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd180ea6fdsm131687156d6.23.2025.01.02.04.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 04:19:51 -0800 (PST)
Message-ID: <8adfcd5a10cf5f96a4b3f46df1490bd4dca5c232.camel@gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: Correct l_next_free_rec in online check
From: Julian Sun <sunjunchao2870@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com, jlbec@evilplan.org
Date: Thu, 02 Jan 2025 20:19:46 +0800
In-Reply-To: <2f18ddcc-405f-4e21-92be-dc70d133f131@linux.alibaba.com>
References: <20250102035321.391540-1-sunjunchao2870@gmail.com>
	 <20250102035321.391540-2-sunjunchao2870@gmail.com>
	 <2f18ddcc-405f-4e21-92be-dc70d133f131@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

T24gVGh1LCAyMDI1LTAxLTAyIGF0IDE0OjU0ICswODAwLCBKb3NlcGggUWkgd3JvdGU6Cj4gCj4g
Cj4gT24gMjAyNS8xLzIgMTE6NTMsIEp1bGlhbiBTdW4gd3JvdGU6Cj4gPiBDb3JyZWN0IHRoZSB2
YWx1ZSBvZiBsX25leHRfZnJlZV9yZWMgdG8gbF9jb3VudCBkdXJpbmcgdGhlIG9ubGluZQo+ID4g
Y2hlY2ssIGFzIGRvbmUgaW4gdGhlIGNoZWNrX2VsKCkgZnVuY3Rpb24gaW4gb2NmczJfdG9vbHMu
Cj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IEp1bGlhbiBTdW4gPHN1bmp1bmNoYW8yODcwQGdtYWls
LmNvbT4KPiA+IC0tLQo+ID4gwqBmcy9vY2ZzMi9pbm9kZS5jIHwgMjQgKysrKysrKysrKysrKysr
KysrKysrKysrCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspCj4gPiAKPiA+
IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9pbm9kZS5jIGIvZnMvb2NmczIvaW5vZGUuYwo+ID4gaW5k
ZXggMmNjNWM5OWZlOTQxLi4xZmM5NTQ0ZGMxZmEgMTAwNjQ0Cj4gPiAtLS0gYS9mcy9vY2ZzMi9p
bm9kZS5jCj4gPiArKysgYi9mcy9vY2ZzMi9pbm9kZS5jCj4gPiBAQCAtMjAwLDYgKzIwMCwyMCBA
QCBzdHJ1Y3QgaW5vZGUgKm9jZnMyX2lnZXQoc3RydWN0IG9jZnMyX3N1cGVyICpvc2IsIHU2NCBi
bGtubywgdW5zaWduZWQgZmxhZ3MsCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGlub2RlOwo+
ID4gwqB9Cj4gPiDCoAo+ID4gK3N0YXRpYyBpbnQgaGFzX2V4dGVudHMoc3RydWN0IG9jZnMyX2Rp
bm9kZSAqZGkpCj4gCj4gQmV0dGVyIHRvIHJlbmFtZSBpdCB0byAnb2NmczJfZGlub2RlX2hhc19l
eHRlbnRzJy4KClJlYXNvbmFibGUuCj4gCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKgLyogaW5v
ZGVzIGZsYWdnZWQgd2l0aCBvdGhlciBzdHVmZiBpbiBpZDIgKi8KPiA+ICvCoMKgwqDCoMKgwqDC
oGlmIChkaS0+aV9mbGFncyAmIChPQ0ZTMl9TVVBFUl9CTE9DS19GTCB8IE9DRlMyX0xPQ0FMX0FM
TE9DX0ZMIHwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBPQ0ZTMl9DSEFJTl9GTCB8IE9DRlMyX0RFQUxMT0NfRkwpKQo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+ID4gK8KgwqDCoMKgwqDCoMKgLyogaV9m
bGFncyBkb2Vzbid0IGluZGljYXRlIHdoZW4gaWQyIGlzIGEgZmFzdCBzeW1saW5rICovCj4gPiAr
wqDCoMKgwqDCoMKgwqBpZiAoU19JU0xOSyhkaS0+aV9tb2RlKSAmJiBkaS0+aV9zaXplICYmIGRp
LT5pX2NsdXN0ZXJzID09IDApCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIDA7Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoZGktPmlfZHluX2ZlYXR1cmVzICYgT0NGUzJf
SU5MSU5FX0RBVEFfRkwpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJu
IDA7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gMTsKPiA+ICt9Cj4gPiDCoAo+ID4g
wqAvKgo+ID4gwqAgKiBoZXJlJ3MgaG93IGlub2RlcyBnZXQgcmVhZCBmcm9tIGRpc2s6Cj4gPiBA
QCAtMTUyOCw2ICsxNTQyLDE2IEBAIHN0YXRpYyBpbnQgb2NmczJfZmlsZWNoZWNrX3JlcGFpcl9p
bm9kZV9ibG9jayhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gLU9DRlMyX0ZJTEVDSEVDS19FUlJfVkFMSURGTEFHOwo+ID4g
wqDCoMKgwqDCoMKgwqDCoH0KPiA+IMKgCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoaGFzX2V4dGVu
dHMoZGkpICYmIGxlMTZfdG9fY3B1KGRpLT5pZDIuaV9saXN0LmxfbmV4dF9mcmVlX3JlYykgPgo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIGxlMTZfdG9fY3B1KGRpLT5pZDIuaV9saXN0LmxfY291
bnQpKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGktPmlkMi5pX2xpc3Qu
bF9uZXh0X2ZyZWVfcmVjID0gZGktPmlkMi5pX2xpc3QubF9jb3VudDsKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBjaGFuZ2VkID0gMTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBtbG9nKE1MX0VSUk9SLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICJGaWxlY2hlY2s6IHJlc2V0IGRpbm9kZSAjJWxsdTogbF9uZXh0X2ZyZWVf
cmVjIHRvICV1XG4iLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICh1bnNpZ25lZCBsb25nIGxvbmcpYmgtPmJfYmxvY2tuciwKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsZTE2X3RvX2NwdShkaS0+aWQyLmlfbGlzdC5sX25leHRf
ZnJlZV9yZWMpKTsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiA+ICsKPiAKPiBJJ2QgbGlrZSB0byBt
b3ZlIHRoaXMgY2hlY2sgYmVoaW5kIGZzX2dlbmVyYXRpb24gc2luY2UgdGhleSBhcmUgY29tbW9u
ZXIgY2hlY2suCgpTdXJlLCB3aWxsIGZpeCBpdCBpbiBuZXh0IHZlcnNpb24uCj4gCj4gVGhhbmtz
LAo+IEpvc2VwaAo+IAo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChsZTY0X3RvX2NwdShkaS0+aV9i
bGtubykgIT0gYmgtPmJfYmxvY2tucikgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBkaS0+aV9ibGtubyA9IGNwdV90b19sZTY0KGJoLT5iX2Jsb2NrbnIpOwo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjaGFuZ2VkID0gMTsKPiAKCi0tIApKdWxpYW4gU3Vu
IDxzdW5qdW5jaGFvMjg3MEBnbWFpbC5jb20+Cg==

