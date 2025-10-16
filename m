Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A12E62D4
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760628781; cv=none; b=MHUX7cY1z6m8zmijhGM5wueM04locinCbnWnYP9SAMx2e0JNzQS5hFNOCYpZfyDXHoDWJpxE5ZrwBJ8+FehrLL7/qliQNjfSwUoxIh1poo0Qs1f4bM9JFJbryPbQS05Q1qS/hl98cb/abfQqc1fHnJmNMzKKjbhl9esniGLtlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760628781; c=relaxed/simple;
	bh=cXG1Y1swLE9XaE9+kqRqC54WZ18XC/n+iduFJeMp1iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMJzP836x0JTkqe6kQTHmmwwnRyd5AcgBMl8QH2kQvRBalEAo/vE9xJ7XJTSev8SIM/9/SbGSATImOWWTJ45NADALIa81rLevTlutXPCCJ3zL6m+eoTDFpvYwpudWUnnKIbrxxCCUoQL2IP0gTafvI5R23lsLeHhGdm/BvxjXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=uydqFXcV; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="uydqFXcV"
Received: from mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:90aa:0:640:875f:0])
	by forward501a.mail.yandex.net (Yandex) with ESMTPS id 91C8880AE7;
	Thu, 16 Oct 2025 18:25:02 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 1PTFoUdLwqM0-eMhUpJKj;
	Thu, 16 Oct 2025 18:25:01 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760628301; bh=cXG1Y1swLE9XaE9+kqRqC54WZ18XC/n+iduFJeMp1iw=;
	h=In-Reply-To:To:From:Cc:Date:References:Subject:Message-ID;
	b=uydqFXcVE4PMSTUPj5giptVpyHA21i+kXS6TsMvqOBDSSrZSZ2SXgnu7Lmfd4NgnU
	 RdRfeE1ZS+G4TA2SyBcib9aM4nkH42/54VmAkLAJl0Sy0y4jwiye0FwhKTqlXFAz7E
	 b840OevcLLquanaOFTYaO6JI+lUJKTANsx0foquI=
Authentication-Results: mail-nwsmtp-smtp-production-main-69.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <4a5bae73-8831-4bf5-ac35-690380ad7ce9@yandex.ru>
Date: Thu, 16 Oct 2025 18:25:00 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add directory size check to
 ocfs2_find_dir_space_id()
Content-Language: en-MW
To: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
References: <20251013103709.146001-1-dmantipov@yandex.ru>
 <fe37aa24-30c0-4c7c-83de-e3df6a9dac6a@suse.com>
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <fe37aa24-30c0-4c7c-83de-e3df6a9dac6a@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMTYvMjUgMjo1OCBQTSwgSGVtaW5nIFpoYW8gd3JvdGU6DQoNCj4+IGRpZmYgLS1n
aXQgYS9mcy9vY2ZzMi9kaXIuYyBiL2ZzL29jZnMyL2Rpci5jDQo+PiBpbmRleCBiOWJmMTQy
OGEzZDkuLjNjMmRhY2JhOWIwYSAxMDA2NDQNCj4+IC0tLSBhL2ZzL29jZnMyL2Rpci5jDQo+
PiArKysgYi9mcy9vY2ZzMi9kaXIuYw0KPj4gQEAgLTM0NDQsNiArMzQ0NCwxNCBAQCBzdGF0
aWMgaW50IG9jZnMyX2ZpbmRfZGlyX3NwYWNlX2lkKHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1
Y3QgYnVmZmVyX2hlYWQgKmRpX2JoLA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIG9mZnNldCAr
PSBsZTE2X3RvX2NwdShkZS0+cmVjX2xlbik7DQo+PiDCoMKgwqDCoMKgIH0NCj4+ICvCoMKg
wqAgaWYgKCFsYXN0X2RlKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gb2NmczJfZXJy
b3Ioc2IsICJEaXJlY3RvcnkgZW50cnkgKCMlbGx1OiBzaXplPSVsbGQpICINCj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJpcyB1bmV4cGVjdGVkbHkgc2hvcnQi
LA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHVuc2lnbmVkIGxv
bmcgbG9uZylPQ0ZTMl9JKGRpciktPmlwX2Jsa25vLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaV9zaXplX3JlYWQoZGlyKSk7DQo+PiArwqDCoMKgwqDCoMKg
wqAgZ290byBvdXQ7DQo+PiArwqDCoMKgIH0NCj4+ICsNCj4gDQo+IFRoZSAnZ290bycgd2ls
bCB1c2UgdGhlIHVuaW5pdGlhbGl6ZWQgdmFsdWUgb2YgJ3JldCcuDQo+IFRoZSBvdGhlcnMg
bG9vayBnb29kIHRvIG1lLg0KDQpIbW1tLi4uICdyZXQnIGlzIGV4cGxpY2l0bHkgaW5pdGlh
bGl6ZWQgd2l0aCAnb2NmczJfZXJyb3IoLi4uKScsDQp3aGljaCBpcyBleHBlY3RlZCB0byBy
ZXR1cm4gZWl0aGVyIC1FSU8gb3IgLUVST0ZTLg0KDQpEbWl0cnkNCg0K
