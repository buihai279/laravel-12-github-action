<?php

namespace Tests\Feature;

use Tests\TestCase;

class Code1ApiTest extends TestCase
{
    /**
     * Test code 1 API endpoint returns successful response.
     */
    public function test_code1_api_returns_successful_response(): void
    {
        $response = $this->get('/api/code1');

        $response
            ->assertStatus(200)
            ->assertJson([
                'message' => 'Code 1 API endpoint',
                'status' => 'success',
                'data' => [
                    'id' => 1,
                    'name' => 'Theo TTD',
                    'description' => 'Test-driven development example'
                ]
            ]);
    }

    /**
     * Test code 1 API endpoint structure.
     */
    public function test_code1_api_structure(): void
    {
        $response = $this->get('/api/code1');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'message',
                'status',
                'data' => [
                    'id',
                    'name',
                    'description'
                ]
            ]);
    }
}