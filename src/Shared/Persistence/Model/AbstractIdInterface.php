<?php

namespace App\Shared\Persistence\Model;

use Stringable;

interface AbstractIdInterface extends Stringable {
    public function toInt(): int;

    /**
     * @param static|null $other
     */
    public function equalTo(?self $other): bool;
}
